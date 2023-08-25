#ifndef __LYK_H
#define __LYK_H

#include "lobject.h"
#include "lopcodes.h"
#include "lstate.h"

void yk_on_newproto(Proto *f);

void yk_ok_instruction_loaded(Proto *f, Instruction i, int idx);

void yk_on_proto_loaded(Proto *f);

void yk_on_proto_free(Proto *f);

YkLocation* yk_lookup_ykloc(CallInfo *ci, Instruction *pc);

#endif // __LYK_H
