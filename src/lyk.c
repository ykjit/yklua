#ifdef USE_YK

#include "lyk.h"
#include "lobject.h"
#include "lopcodes.h"
#include "ldebug.h"
#include <stdlib.h>
#include <yk.h>

#define _DEFAULT_SOURCE /* for reallocarray() */

/*
 *  Function prototypes in Lua are loaded through two methods:
 *    1.  They are loaded from text source via the `luaY_parser`.
 *    2.  They can also be loaded from binary representation using `luaU_undump`, where
 *        prototypes are previously dumped and saved.
 * 
 *  Yk tracing locations are allocated using both of these methods 
 *  using `yk_set_location` and `yk_set_locations` respectively.
*/

/*
 *  Is the instruction `i` the start of a loop?
 *
 *  YKFIXME: Numeric and Generic loops can be identified by `OP_FORLOOP` and `OP_TFORLOOP` opcodes. 
 *  Other loops like while and repeat-until are harder to identify since they are based on 
 *  `OP_JMP` instruction.
 */
int is_loop_start(Instruction i) {
  return (GET_OPCODE(i) == OP_FORLOOP || GET_OPCODE(i) == OP_TFORLOOP);
}

inline YkLocation *yk_lookup_ykloc(CallInfo *ci, Instruction *pc){
  YkLocation *ykloc = NULL;
  lua_assert(isLua(ci));
  Proto *p = ci_func(ci)->p;
  lua_assert(p->code <= pc && pc <= p->code + p->sizecode);
  if (is_loop_start(*pc)) {
    ykloc = &p->yklocs[pc - p->code];
  }
  return ykloc;
}

inline void yk_set_location(Proto *f, Instruction i, int idx, int pc) {
  // YKOPT: Reallocating for every instruction is inefficient.
  f->yklocs = reallocarray(f->yklocs, pc, sizeof(YkLocation));
  lua_assert(f->yklocs != NULL && "Expected yklocs to be defined!");
  if (is_loop_start(i))
  {
    f->yklocs[idx] = yk_location_new();
  }
}

inline void yk_set_locations(Proto *f) {
  f->yklocs = calloc(f->sizecode, sizeof(YkLocation));
  lua_assert(f->yklocs != NULL && "Expected yklocs to be defined!");
  for (int i = 0; i < f->sizecode; i++){
     if (is_loop_start(i)){
      f->yklocs[i] = yk_location_new();
    }
  }
}

void free_loc(Proto *f, Instruction i, int idx) {
  if (is_loop_start(i)) {
    yk_location_drop(f->yklocs[idx]);
  }
}

inline void yk_free_locactions(Proto *f) {
  // YK locations are initialised as close as possible to the function loading, 
  // However, this load can fail before we initialise `yklocs`.
  // This NULL check is a workaround for that.
  if (f->yklocs != NULL) {
    for (int i = 0; i < f->sizecode; i++) {
      free_loc(f, f->code[i], i);
    }
    free(f->yklocs);
    f->yklocs = NULL;
  }
}
#endif // USE_YK
