/*
 * opencog/unify/atoms/UnifyReduceLink.h
 *
 * Copyright (C) 2015, 2022 Linas Vepstas
 * All Rights Reserved
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License v3 as
 * published by the Free Software Foundation and including the exceptions
 * at http://opencog.org/wiki/Licenses
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program; if not, write to:
 * Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#ifndef _OPENCOG_UNIFY_REDUCE_LINK_H
#define _OPENCOG_UNIFY_REDUCE_LINK_H

#include <opencog/unify/atoms/UnifierLink.h>

namespace opencog
{
/** \addtogroup grp_atomspace
 *  @{
 */

/// The UnifyReduceLink performs reduction after unification and rewriting.
///
class UnifyReduceLink : public UnifierLink
{
public:
	UnifyReduceLink(const HandleSeq&&, Type = UNIFY_REDUCE_LINK);
	UnifyReduceLink(const UnifyReduceLink&) = delete;
	UnifyReduceLink& operator=(const UnifyReduceLink&) = delete;

	// Return a pointer to the results
	virtual ValuePtr execute(AtomSpace*, bool);

	static Handle factory(const Handle&);
};

LINK_PTR_DECL(UnifyReduceLink)
#define createUnifyReduceLink CREATE_DECL(UnifyReduceLink)

/** @}*/
}
#endif // _OPENCOG_UNIFY_REDUCE_LINK_H
