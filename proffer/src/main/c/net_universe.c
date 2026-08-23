#include "net_universe.h"

ProfferVec3 proffer_memory_fall(ProfferMemoryObject object, int64_t tick) {
    int64_t age = tick > object.born_tick ? tick - object.born_tick : 0;
    ProfferVec3 result = object.position;
    result.z -= (double)age;
    return result;
}

ProfferProcessDiagonal proffer_diagonalize(ProfferVec3 ram, ProfferVec3 processor, double process_time) {
    ProfferProcessDiagonal result = {ram, processor, process_time};
    return result;
}
