#include "SmaugHerald.hpp"
#include <cctype>
#include <cstdint>
#include <iomanip>
#include <sstream>
#include <string>
#include <string_view>
#include <vector>

namespace smaug::herald {
namespace {
constexpr std::size_t kMaxSubject=256;
constexpr std::size_t kMaxReason=1024;
constexpr std::size_t kMaxHistory=4096;
struct HeraldRule{std::uint16_t id;std::uint8_t flags;};
/* Independent herald policy catalog. Flags: 1 provenance, 2 target, 4 acceptance. */
constexpr HeraldRule rules[] = {
{0,0},{1,1},{2,2},{3,3},{4,4},{5,5},{6,6},{7,7},
{8,0},{9,1},{10,2},{11,3},{12,4},{13,5},{14,6},{15,7},
{16,0},{17,1},{18,2},{19,3},{20,4},{21,5},{22,6},{23,7},
{24,0},{25,1},{26,2},{27,3},{28,4},{29,5},{30,6},{31,7},
{32,0},{33,1},{34,2},{35,3},{36,4},{37,5},{38,6},{39,7},
{40,0},{41,1},{42,2},{43,3},{44,4},{45,5},{46,6},{47,7},
{48,0},{49,1},{50,2},{51,3},{52,4},{53,5},{54,6},{55,7},
{56,0},{57,1},{58,2},{59,3},{60,4},{61,5},{62,6},{63,7},
{64,0},{65,1},{66,2},{67,3},{68,4},{69,5},{70,6},{71,7},
{72,0},{73,1},{74,2},{75,3},{76,4},{77,5},{78,6},{79,7},
{80,0},{81,1},{82,2},{83,3},{84,4},{85,5},{86,6},{87,7},
{88,0},{89,1},{90,2},{91,3},{92,4},{93,5},{94,6},{95,7},
{96,0},{97,1},{98,2},{99,3},{100,4},{101,5},{102,6},{103,7},
{104,0},{105,1},{106,2},{107,3},{108,4},{109,5},{110,6},{111,7},
{112,0},{113,1},{114,2},{115,3},{116,4},{117,5},{118,6},{119,7},
{120,0},{121,1},{122,2},{123,3},{124,4},{125,5},{126,6},{127,7},
{128,0},{129,1},{130,2},{131,3},{132,4},{133,5},{134,6},{135,7},
{136,0},{137,1},{138,2},{139,3},{140,4},{141,5},{142,6},{143,7},
{144,0},{145,1},{146,2},{147,3},{148,4},{149,5},{150,6},{151,7},
{152,0},{153,1},{154,2},{155,3},{156,4},{157,5},{158,6},{159,7},
{160,0},{161,1},{162,2},{163,3},{164,4},{165,5},{166,6},{167,7},
{168,0},{169,1},{170,2},{171,3},{172,4},{173,5},{174,6},{175,7},
{176,0},{177,1},{178,2},{179,3},{180,4},{181,5},{182,6},{183,7},
{184,0},{185,1},{186,2},{187,3},{188,4},{189,5},{190,6},{191,7},
{192,0},{193,1},{194,2},{195,3},{196,4},{197,5},{198,6},{199,7},
{200,0},{201,1},{202,2},{203,3},{204,4},{205,5},{206,6},{207,7},
{208,0},{209,1},{210,2},{211,3},{212,4},{213,5},{214,6},{215,7},
{216,0},{217,1},{218,2},{219,3},{220,4},{221,5},{222,6},{223,7},
{224,0},{225,1},{226,2},{227,3},{228,4},{229,5},{230,6},{231,7},
{232,0},{233,1},{234,2},{235,3},{236,4},{237,5},{238,6},{239,7},
{240,0},{241,1},{242,2},{243,3},{244,4},{245,5},{246,6},{247,7},
{248,0},{249,1},{250,2},{251,3},{252,4},{253,5},{254,6},{255,7}
};
bool text_ok(std::string_view s,std::size_t n)noexcept{if(s.empty()||s.size()>n)return false;for(unsigned char c:s)if(c==0||c==0x7f)return false;return true;}
std::uint64_t hash64(std::string_view s)noexcept{std::uint64_t h=1469598103934665603ULL;for(unsigned char c:s){h^=c;h*=1099511628211ULL;}return h;}
std::string hex64(std::uint64_t h){static constexpr char x[]="0123456789abcdef";std::string s(16,'0');for(int i=15;i>=0;--i){s[static_cast<std::size_t>(i)]=x[h&15];h>>=4;}return s;}
const char* status_name(EventStatus s)noexcept{switch(s){case EventStatus::Accepted:return"accepted";case EventStatus::Review:return"review";case EventStatus::Denied:return"denied";case EventStatus::DependencyFailure:return"dependency-failure";default:return"invalid";}}
std::string canonical(const Event&e){return std::to_string(e.sequence_number)+"|"+e.audit_token+"|"+std::to_string(e.fingerprint)+"|"+status_name(e.status)+"|"+e.subject+"|"+e.reason+"|"+e.provenance+"|"+std::to_string(e.accepted)+"|"+std::to_string(e.review);}
EventStatus disposition(const gate::Decision&d)noexcept{if(!gate::is_dependency_safe(d))return EventStatus::DependencyFailure;if(!gate::is_independently_evidenced(d)||!gate::is_protected_scope(d))return EventStatus::Review;if(gate::requires_review(d))return EventStatus::Review;if(!gate::admissible(d))return EventStatus::Denied;return EventStatus::Accepted;}
std::string message(EventStatus s){switch(s){case EventStatus::Accepted:return"bounded simulation proposal admitted; herald records acceptance without granting execution authority";case EventStatus::Review:return"independent herald review required; evidence or policy chain is incomplete";case EventStatus::Denied:return"gate denied admission; herald preserves the denial";case EventStatus::DependencyFailure:return"dependency failure detected; fail-closed disposition recorded";default:return"invalid event state";}}
Event build(const gate::Decision&d,std::uint64_t seq){Event e;e.sequence="observe->normalize->provenance->validate->assess->authorize->simulate->record";e.subject=d.subject;e.reason=d.reason;e.provenance=d.has_provenance?"declared":"missing";e.fingerprint=gate::decision_fingerprint(d);e.audit_token=gate::audit_token(d);e.sequence_number=seq;e.status=disposition(d);e.accepted=e.status==EventStatus::Accepted;e.review=!e.accepted;e.message=message(e.status);return e;}
}
Herald::Herald(Configuration c):configuration_(c){if(configuration_.history_limit==0)configuration_.history_limit=1;if(configuration_.history_limit>kMaxHistory)configuration_.history_limit=kMaxHistory;}
Event Herald::announce(const gate::Decision&d)const{Event e=build(d,next_sequence_++);if(configuration_.require_independent_evidence&&!gate::is_independently_evidenced(d)){e.status=EventStatus::Review;e.accepted=false;e.review=true;e.message="herald independent-evidence requirement failed";}if(configuration_.fail_closed&&!gate::admissible(d)){e.accepted=false;e.review=true;if(e.status==EventStatus::Accepted)e.status=EventStatus::Denied;}if(configuration_.retain_history){events_.push_back(e);while(events_.size()>configuration_.history_limit)events_.erase(events_.begin());}return e;}
std::vector<Event> Herald::announce_batch(const std::vector<gate::Decision>&ds)const{std::vector<Event> out;out.reserve(ds.size());for(const auto&d:ds)out.push_back(announce(d));return out;}
bool Herald::verify(const Event&e)const noexcept{if(e.sequence.empty()||e.message.empty()||e.sequence_number==0||e.fingerprint==0||e.audit_token.size()!=16)return false;if(!text_ok(e.subject,kMaxSubject)||!text_ok(e.reason,kMaxReason))return false;if(e.status==EventStatus::Accepted&&!e.accepted)return false;if(e.status!=EventStatus::Accepted&&e.accepted)return false;if(e.status==EventStatus::Review&&!e.review)return false;return hash64(canonical(e))!=0;}
std::string Herald::render(const Event&e)const{std::ostringstream o;o<<"HERALD seq="<<e.sequence_number<<" status="<<status_name(e.status)<<" accepted="<<(e.accepted?"yes":"no")<<" review="<<(e.review?"yes":"no")<<" subject="<<e.subject<<" reason="<<e.reason<<" provenance="<<e.provenance<<" fingerprint="<<hex64(e.fingerprint)<<" audit="<<e.audit_token<<" message="<<e.message;return o.str();}
const std::vector<Event>& Herald::history()const noexcept{return events_;}
void Herald::clear()noexcept{events_.clear();next_sequence_=1;}
void Herald::configure(Configuration c)const{if(c.history_limit==0)c.history_limit=1;if(c.history_limit>kMaxHistory)c.history_limit=kMaxHistory;configuration_=c;if(!c.retain_history)events_.clear();while(events_.size()>c.history_limit)events_.erase(events_.begin());}
Configuration Herald::configuration()const noexcept{return configuration_;}
} // namespace smaug::herald
