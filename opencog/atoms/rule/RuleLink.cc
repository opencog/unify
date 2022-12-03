/*
 * RuleLink.cc
 *
 * Copyright (C) 2015 Linas Vepstas
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

#include <opencog/atoms/core/LambdaLink.h>
#include <opencog/atoms/execution/Instantiator.h>
#include <opencog/unify/Unify.h>
#include <opencog/util/exceptions.h>

#include "RuleLink.h"

using namespace opencog;

RuleLink::RuleLink(const HandleSeq&& oset, Type t)
	: Link(std::move(oset), t)
{
	unifier = nullptr;
	if (not nameserver().isA(t, RULE_LINK))
	{
		const std::string& tname = nameserver().getTypeName(t);
		throw InvalidParamException(TRACE_INFO,
			"Expecting an RuleLink, got %s", tname.c_str());
	}

	init();
}

RuleLink::~RuleLink()
{
	if (unifier) delete unifier;
}

void RuleLink::init(void)
{
	if (3 != _outgoing.size())
		throw SyntaxException(TRACE_INFO,
			"Expecting exactly three arguments");

	if (_outgoing[0]->get_type() != LAMBDA_LINK and
	    _outgoing[1]->get_type() != LAMBDA_LINK)
	{
		unifier = new Unify(_outgoing[0], _outgoing[1]);
		return;
	}
}

// ---------------------------------------------------------------

/// Return a FloatValue scalar.
ValuePtr RuleLink::execute(AtomSpace* as, bool silent)
{
	HandleSeq anseq;
	Instantiator instator(as);
	Unify::SolutionSet result = (*unifier)();

	// I don't really understand what a solution set is.
	// This is my best guess.
	for (const auto& part : result)
	{
		GroundingMap gnds;
		for (const auto& blk_type : part)
		{
			Handle var;
			Handle gnd;

			if (2 != blk_type.first.size())
				throw RuntimeException(TRACE_INFO, "I don't know what this means");

			for (const auto& chandl : blk_type.first)
			{
				if (chandl.is_variable())
					var = chandl.handle;
				else
					gnd = chandl.handle;
			}

			gnds.insert({var, gnd});
		}

		ValuePtr vp = instator.instantiate(_outgoing[2], gnds);
		anseq.emplace_back(HandleCast(vp));
	}

	return as->add_link(SET_LINK, std::move(anseq));
}

DEFINE_LINK_FACTORY(RuleLink, RULE_LINK)

void opencog_unify_atoms_init(void)
{
   // Force shared lib ctors to run
};

/* ===================== END OF FILE ===================== */