//low-level trap handler glue code
#include "mmu.h"
	
.global trap_swi
.global trap_irq
.global trap_reset
.global trap_und
.global trap_pabort
.global trap_dabort
.global trap_reserved
.global trap_fiq
@.global trapret


# handle SWI, we allow nested SWI
trap_swi:
	
# handle IRQ, we allow nested IRQs
trap_irq:

	
# handle reset/undefine instruction/abort/not-assigned/fiq
# these handler does not allow nested handling
trap_reset:

trap_und:

trap_pabort:

trap_dabort:

trap_reserved:			    

trap_fiq:
