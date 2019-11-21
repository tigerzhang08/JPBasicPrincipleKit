/* Common definition for strcasecmp famly ifunc selections.
   All versions must be listed in ifunc-impl-list.c.
   Copyright (C) 2017-2019 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, see
   <http://www.gnu.org/licenses/>.  */

#include <init-arch.h>

extern __typeof (REDIRECT_NAME) OPTIMIZE (sse2) attribute_hidden;
extern __typeof (REDIRECT_NAME) OPTIMIZE (ssse3) attribute_hidden;
extern __typeof (REDIRECT_NAME) OPTIMIZE (sse42) attribute_hidden;
extern __typeof (REDIRECT_NAME) OPTIMIZE (avx) attribute_hidden;

static inline void *
IFUNC_SELECTOR (void)
{
  const struct cpu_features* cpu_features = __get_cpu_features ();

  if (CPU_FEATURES_ARCH_P (cpu_features, AVX_Usable))
    return OPTIMIZE (avx);

  if (CPU_FEATURES_CPU_P (cpu_features, SSE4_2)
      && !CPU_FEATURES_ARCH_P (cpu_features, Slow_SSE4_2))
    return OPTIMIZE (sse42);

  if (CPU_FEATURES_CPU_P (cpu_features, SSSE3))
    return OPTIMIZE (ssse3);

  return OPTIMIZE (sse2);
}
