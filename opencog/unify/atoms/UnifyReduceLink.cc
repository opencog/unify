/*
 * UnifyReduceLink.cc
 *
 * Copyright (C) 2015, 2022 Linas Vepstas
 *
 * Author: Linas Vepstas <linasvepstas@gmail.com>  January 2009
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License v3 as
 * published by the Free Software Foundation and including the
 * exceptions at http://opencog.org/wiki/Licenses
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public
 * License along with this program; if not, write to:
 * Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#include <opencog/util/exceptions.h>
#include <opencog/atoms/value/LinkValue.h>
#include <opencog/atomspace/AtomSpace.h>

#include "UnifyReduceLink.h"

using namespace opencog;

UnifyReduceLink::UnifyReduceLink(const HandleSeq&& oset, Type t)
	: UnifierLink(std::move(oset), t)
{
	if (not nameserver().isA(t, UNIFY_REDUCE_LINK))
	{
		const std::string& tname = nameserver().getTypeName(t);
		throw InvalidParamException(TRACE_INFO,
			"Expecting an UnifyReduceLink, got %s", tname.c_str());
	}
}

// ---------------------------------------------------------------

/// Return a FloatValue scalar.
ValuePtr UnifyReduceLink::execute(AtomSpace* as, bool silent)
{
	HandleSeq anseq(rewrite(as, silent));
	HandleSeq redseq;
	for (const Handle& h: anseq)
	{
		if (h->is_type(EXECUTABLE_LINK))
			redseq.emplace_back(HandleCast(h->execute()));
		else
			redseq.emplace_back(h);
	}

	return createLinkValue(redseq);
}

DEFINE_LINK_FACTORY(UnifyReduceLink, UNIFY_REDUCE_LINK)

/* ===================== END OF FILE ===================== */
