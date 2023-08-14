#ifndef __LYK_H
#define __LYK_H

#include "lobject.h"
#include "lopcodes.h"
#include "lstate.h"

void yk_set_location(Proto *f, Instruction i, int idx, int pc);

void yk_set_locations(Proto *f);

void yk_free_locactions(Proto *f);

YkLocation* yk_lookup_ykloc(CallInfo *ci, Instruction *pc);

#endif // __LYK_H
