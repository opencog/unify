/*
 * UnifierLink.cc
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

#include <opencog/atoms/core/LambdaLink.h>
#include <opencog/atoms/execution/Instantiator.h>
#include <opencog/atoms/value/LinkValue.h>
#include <opencog/unify/Unify.h>
#include <opencog/util/exceptions.h>

#include "UnifierLink.h"

using namespace opencog;

UnifierLink::UnifierLink(const HandleSeq&& oset, Type t)
	: Link(std::move(oset), t)
{
	_unifier = nullptr;
	if (not nameserver().isA(t, UNIFIER_LINK))
	{
		const std::string& tname = nameserver().getTypeName(t);
		throw InvalidParamException(TRACE_INFO,
			"Expecting an UnifierLink, got %s", tname.c_str());
	}

	init();
}

UnifierLink::~UnifierLink()
{
	if (_unifier) delete _unifier;
}

void UnifierLink::init(void)
{
	if (3 != _outgoing.size())
		throw SyntaxException(TRACE_INFO,
			"Expecting exactly three arguments");

	_is_dynamic = true;
	// If the arguments are static, then we can process them
	// at constructor time.
	if (not _outgoing[0]->is_type(EXECUTABLE_LINK) and
	    not _outgoing[1]->is_type(EXECUTABLE_LINK))
	{
		make_uni(_outgoing);
		_is_dynamic = false;
	}
}

void UnifierLink::make_uni(const HandleSeq& oset)
{
	if (_unifier) delete _unifier;

	if (oset[0]->get_type() != LAMBDA_LINK and
	    oset[1]->get_type() != LAMBDA_LINK)
	{
		_unifier = new Unify(oset[0], oset[1]);
		return;
	}

	static Variables empty;

	// Else one or both are lambdas.
	if (oset[0]->get_type() == LAMBDA_LINK and
	    oset[1]->get_type() != LAMBDA_LINK)
	{
		const LambdaLinkPtr& lhs = LambdaLinkCast(oset[0]);
		_unifier = new Unify(
			lhs->get_body(), oset[1],
			lhs->get_variables(), empty);
		return;
	}

	if (oset[0]->get_type() != LAMBDA_LINK and
	    oset[1]->get_type() == LAMBDA_LINK)
	{
		const LambdaLinkPtr& rhs = LambdaLinkCast(oset[1]);
		_unifier = new Unify(
			oset[0], rhs->get_body(),
			empty, rhs->get_variables());
		return;
	}

	const LambdaLinkPtr& lhs = LambdaLinkCast(oset[0]);
	const LambdaLinkPtr& rhs = LambdaLinkCast(oset[1]);
	_unifier = new Unify(
		lhs->get_body(), rhs->get_body(),
		lhs->get_variables(), rhs->get_variables());
}

// ---------------------------------------------------------------

/// Return a list of all of the rewritten targets.
HandleSeq UnifierLink::rewrite(AtomSpace* as, bool silent)
{
	// If the args are executable, we execute them now,
	// so as to find out what they are.
	if (_is_dynamic)
	{
		HandleSeq oset;
		if (_outgoing[0]->is_type(EXECUTABLE_LINK))
			oset.emplace_back(HandleCast(_outgoing[0]->execute()));
		else
			oset.emplace_back(_outgoing[0]);

		if (_outgoing[1]->is_type(EXECUTABLE_LINK))
			oset.emplace_back(HandleCast(_outgoing[1]->execute()));
		else
			oset.emplace_back(_outgoing[1]);

		make_uni(oset);
	}

	HandleSeq anseq;
	Instantiator instator(as);
	Unify::SolutionSet result = (*_unifier)();

	// I don't really understand what a solution set is.
	// This is my best guess.

	// XXX FIXME, Maybe. This seems to handle all of the cases I've
	// looked at so far. However, the unifier has all sorts of fancy
	// reduction code, and I don't understand what it is or why it
	// is needed. For example, Unfiy::typed_substitutions() and other
	// methods... What do they do? Do we really need them?

	for (const auto& part : result)
	{
		GroundingMap gndmap;
		for (const auto& blk_type : part)
		{
			Handle var;
			HandleSeq gnds;

			// There may be more than one grounding. This can happen
			// when the expr is of the form
			//    `(Foo (Variable "$P") (Bar (Variable "$P")))`
			// and the first P matches one thing, and the second matches
			// another and yet they ar both internally consistent matches.
			for (const auto& chandl : blk_type.first)
			{
				if (chandl.is_variable())
					var = chandl.handle;
				else
					gnds.push_back(chandl.handle);
			}

			if (1 == gnds.size())
				gndmap.insert({var, gnds[0]});
			else
			{
				Handle gh = as->add_link(CHOICE_LINK, std::move(gnds));
				gndmap.insert({var, gh});
			}
		}

		ValuePtr vp = instator.instantiate(_outgoing[2], gndmap);
		anseq.emplace_back(HandleCast(vp));
	}

	return anseq;
}

// ---------------------------------------------------------------

/// Return the set of all possible rewrites after unification.
ValuePtr UnifierLink::execute(AtomSpace* as, bool silent)
{
	return createLinkValue(rewrite(as, silent));
}

DEFINE_LINK_FACTORY(UnifierLink, UNIFIER_LINK)

// ---------------------------------------------------------------

void opencog_unify_atoms_init(void)
{
   // Force shared lib ctors to run
};

/* ===================== END OF FILE ===================== */
