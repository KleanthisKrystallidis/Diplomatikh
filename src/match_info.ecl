/*
    Copyright (C) 2008 Stephan Schiffel <stephan.schiffel@gmx.de>

    This file is part of the GGP starter code.

    The GGP starter code is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    The GGP starter code is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with the GGP starter code.  If not, see <http://www.gnu.org/licenses/>.
*/

:- module(match_info, [
	set_match_id/1,
	get_match_id/1 ,
	
	set_sumval/1,
	get_sumval/1,
	
	set_sumsc/1,
	get_sumsc/1,
	
	set_sumvalps/1,
	get_sumvalps/1,
	
	set_sumscps/1,
	get_sumscps/1,
	
	set_counterst/1,
	get_counterst/1,
	
	set_countersub/1,
	get_countersub/1,
	
	set_counterstsub/1,
	get_counterstsub/1,
	
	set_final_term_list/1,
	get_final_term_list/1,
	
	set_sumvaldiff/1,
	get_sumvaldiff/1,
	
	set_sumvaldiffsub/1,
	get_sumvaldiffsub/1,
	
	set_sumvaldiffsq/1,
	get_sumvaldiffsq/1,
	
	set_sumscdiff/1,
	get_sumscdiff/1,
	
	set_countersv/1,
	get_countersv/1,
	
	set_sumsv/1,
	get_sumsv/1,
	
	set_score_sum/1,
	get_score_sum/1,
	
	set_sum_val_score_prod/1,
	get_sum_val_score_prod/1,
	
	set_expected_score/1,
	get_expected_score/1,
	
	set_eval/1,
	get_eval/1,
	
	set_feature_stat_term_list/1,
	get_feature_stat_term_list/1,

	set_move_id_list/1,
	get_move_id_list/1,

	set_move_id/1,
	get_move_id/1,

	set_maxi/1,
	get_maxi/1,

	set_idmaxi/1,
	get_idmaxi/1,

	set_scores/1,
	get_scores/1,

	set_seq_list/1,
	get_seq_list/1,

	set_subseq_list/1,
	get_subseq_list/1,

	set_our_role/1,
	get_our_role/1,
	
	set_startclock/1,
	get_startclock/1,

	set_playclock/1,
	get_playclock/1,

	set_current_state/1,
	get_current_state/1,
	
	set_current_best_move/1,
	get_current_best_move/1,
	
	set_ene_role/1,
	get_ene_role/1,
	
	set_agent_name/1,
	get_agent_name/1,
	
	set_carrier/1,
	get_carrier/1,
	
	set_feature_list/1,
	get_feature_list/1
	], eclipse_language).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Made a lot of variables that did not exist *Kleanthis Krystallidis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- local variable(agent_name, my_agent).
:- mode set_agent_name(++).
set_agent_name(V) :- setval(agent_name, V).
get_agent_name(V) :- getval(agent_name, V).

:- local variable(carrier, 0).
:- mode set_carrier(++).
set_carrier(V) :- setval(carrier, V).
get_carrier(V) :- getval(carrier, V).

:- local variable(currentmatch, "none").
:- mode set_match_id(++).
set_match_id(V) :- setval(currentmatch, V).
get_match_id(V) :- getval(currentmatch, V).

:- local variable(our_role, none).
:- mode set_our_role(++).
set_our_role(V) :- setval(our_role, V).
get_our_role(V) :- getval(our_role, V).

:- local variable(ene_role, none).
:- mode set_ene_role(++).
set_ene_role(V) :- setval(ene_role, V).
get_ene_role(V) :- getval(ene_role, V).


:- local variable(startclock, 0).
:- mode set_startclock(++).
set_startclock(V) :- setval(startclock, V).
get_startclock(V) :- getval(startclock, V).

:- local variable(playclock, 0).
:- mode set_playclock(++).
set_playclock(V) :- setval(playclock, V).
get_playclock(V) :- getval(playclock, V).

:- local variable(current_state, []).
:- mode set_current_state(++).
set_current_state(V) :- setval(current_state, V).
get_current_state(V) :- getval(current_state, V).

:- local variable(current_best_move, none).
:- mode set_current_best_move(++).
set_current_best_move(V) :- setval(current_best_move, V).
get_current_best_move(V) :- getval(current_best_move, V).

:- local variable(feature_list,[]).
:- mode set_feature_list(++).
set_feature_list(V) :- setval(feature_list, V).
get_feature_list(V) :- getval(feature_list, V).

:- local variable(subseq_list, []).
:- mode set_subseq_list(++).
set_subseq_list(V) :- setval(subseq_list, V).
get_subseq_list(V) :- getval(subseq_list, V).

:- local variable(seq_list, []).    %may cause problems down the way it seeems to add an empty list at the end which is unitended KEEP AN EYE
:- mode set_seq_list(++).
set_seq_list(V) :- setval(seq_list, V).
get_seq_list(V) :- getval(seq_list, V).

:- local variable(scores, []).
:- mode set_scores(++).
set_scores(V) :- setval(scores, V).
get_scores(V) :- getval(scores, V).

:- local variable(idmaxi, 0).
:- mode set_idmaxi(++).
set_idmaxi(V) :- setval(idmaxi, V).
get_idmaxi(V) :- getval(idmaxi, V).
	

:- local variable(maxi, 0).
:- mode set_maxi(++).
set_maxi(V) :- setval(maxi, V).
get_maxi(V) :- getval(maxi, V).
	
	
:- local variable(move_id, []).
:- mode set_move_id(++).
set_move_id(V) :- setval(move_id, V).
get_move_id(V) :- getval(move_id, V).

:- local variable(move_id_list, [[]]).
:- mode set_move_id_list(++).
set_move_id_list(V) :- setval(move_id_list, V).
get_move_id_list(V) :- getval(move_id_list, V).

:- local variable(feature_stat_term_list, []).
:- mode set_feature_stat_term_list(++).
set_feature_stat_term_list(V) :- setval(feature_stat_term_list, V).
get_feature_stat_term_list(V) :- getval(feature_stat_term_list, V).

:- local variable(sumval, 0).
:- mode set_sumval(++).
set_sumval(V) :- setval(sumval, V).
get_sumval(V) :- getval(sumval, V).

:- local variable(sumsc, 0).
:- mode set_sumsc(++).
set_sumsc(V) :- setval(sumsc, V).
get_sumsc(V) :- getval(sumsc, V).

:- local variable(sumvalps, 0).
:- mode set_sumvalps(++).
set_sumvalps(V) :- setval(sumvalps, V).
get_sumvalps(V) :- getval(sumvalps, V).

:- local variable(sumscps, 0).
:- mode set_sumscps(++).
set_sumscps(V) :- setval(sumscps, V).
get_sumscps(V) :- getval(sumscps, V).

:- local variable(counterst, 0).
:- mode set_counterst(++).
set_counterst(V) :- setval(counterst, V).
get_counterst(V) :- getval(counterst, V).

:- local variable(sumvaldiff, 0).
:- mode set_sumvaldiff(++).
set_sumvaldiff(V) :- setval(sumvaldiff, V).
get_sumvaldiff(V) :- getval(sumvaldiff, V).

:- local variable(sumscdiff, 0).
:- mode set_sumscdiff(++).
set_sumscdiff(V) :- setval(sumscdiff, V).
get_sumscdiff(V) :- getval(sumscdiff, V).

:- local variable(sum_val_score_prod, 0).
:- mode set_sum_val_score_prod(++).
set_sum_val_score_prod(V) :- setval(sum_val_score_prod, V).
get_sum_val_score_prod(V) :- getval(sum_val_score_prod, V).

:- local variable(countersub, 0).
:- mode set_countersub(++).
set_countersub(V) :- setval(countersub, V).
get_countersub(V) :- getval(countersub, V).

:- local variable(counterstsub, 0).
:- mode set_counterstsub(++).
set_counterstsub(V) :- setval(counterstsub, V).
get_counterstsub(V) :- getval(counterstsub, V).

:- local variable(sumvaldiffsub, 0).
:- mode set_sumvaldiffsub(++).
set_sumvaldiffsub(V) :- setval(sumvaldiffsub, V).
get_sumvaldiffsub(V) :- getval(sumvaldiffsub, V).

:- local variable(sumvalldiffsq, 0).
:- mode set_sumvaldiffsq(++).
set_sumvaldiffsq(V) :- setval(sumvaldiffsq, V).
get_sumvaldiffsq(V) :- getval(sumvaldiffsq, V).

:- local variable(countersv, 0).
:- mode set_countersv(++).
set_countersv(V) :- setval(countersv, V).
get_countersv(V) :- getval(countersv, V).

:- local variable(sumsv, 0).
:- mode set_sumsv(++).
set_sumsv(V) :- setval(sumsv, V).
get_sumsv(V) :- getval(sumsv, V).

:- local variable(expected_score, 0).
:- mode set_sumsv(++).
set_expected_score(V) :- setval(expected_score, V).
get_expected_score(V) :- getval(expected_score, V).

:- local variable(final_term_list, []).
:- mode set_final_term_list(++).
set_final_term_list(V) :- setval(final_term_list, V).
get_final_term_list(V) :- getval(final_term_list, V).

:- local variable(eval, []).
:- mode set_eval(++).
set_eval(V) :- setval(eval, V).
get_eval(V) :- getval(eval, V).

:- local variable(score_sum, 0).
:- mode set_score_sum(++).
set_score_sum(V) :- setval(score_sum, V).
get_score_sum(V) :- getval(score_sum, V).
