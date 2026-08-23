#ifndef PROFFER_NET_UNIVERSE_H
#define PROFFER_NET_UNIVERSE_H

#include <stdint.h>

typedef struct { double x, y, z; } ProfferVec3;
typedef struct { int64_t id; ProfferVec3 position; double mass; int64_t born_tick; } ProfferMemoryObject;
typedef struct { double net_center; double perfection_tolerance; } ProfferNetUniverse;
typedef struct { ProfferVec3 start, end; double process_time; } ProfferProcessDiagonal;

ProfferVec3 proffer_memory_fall(ProfferMemoryObject object, int64_t tick);
ProfferProcessDiagonal proffer_diagonalize(ProfferVec3 ram, ProfferVec3 processor, double process_time);

#endif
