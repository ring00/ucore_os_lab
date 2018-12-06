#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) {
    // set_csr(sstatus, SSTATUS_SIE);
    asm volatile ("csrrsi x0, sstatus, %0": : "i"(SSTATUS_SIE));
}

/* intr_disable - disable irq interrupt */
void intr_disable(void) {
    // clear_csr(sstatus, SSTATUS_SIE);
    asm volatile ("csrrci x0, sstatus, %0": : "i"(SSTATUS_SIE));
}
