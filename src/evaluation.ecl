:- module(evaluation).

:-export(add_to_feature_list/1).
:-export(discription_feature_finder/0).
:-export(term_manipulator/0).

:- use_module(match_info).
:- use_module(game_description).
:- use_module(listut).
:- use_module(term_combination_finder).

:-mode add_to_feature_list(++).
add_to_feature_list(Feature):-
	get_feature_list(Features),
	append(Feature,Features,Features1),
	sort(Features1,FeaturesC),
	list_unique(FeaturesC,FeaturesD),
	%print_list(FeaturesC),
	set_feature_list(FeaturesD).

add_to_feature_list2(Feature):-
	get_feature_list2(Features),
	append(Feature,Features,Features1),
	set_feature_list2(Features1).
	
discription_feature_finder:-
	base_pred(Features),
	add_to_feature_list(Features).

term_manipulator:-
	get_feature_list(Features),
	create_general_terms(Features),
	get_feature_list2(F),add_to_feature_list(F),get_feature_list(K),print_list(K).

:-mode create_general_terms(++).
create_general_terms(Features):-
	(foreach(Feature,Features) do 
		(functor(Feature,Name,Arrity),
		make_argument_list(Feature,Arg_List),
		viable_arg_list(Arg_List)->
			general_term_helper(Arg_List,Name,Arrity)
		;
			true)
	).
	
general_term_helper(Arg_List,Name,Arrity):-
	functor(New_term,Name,Arrity),
	add_to_feature_list2([New_term]),Counter is Arrity - 1,
	combination_finder(New_term,Arrity,Counter,[],M,Arg_List),
	add_to_feature_list2(M).

make_argument_list(Feature,Arg_List):-
(foreacharg(X,Feature), foreach(X,Arg_List) do true).

viable_arg_list(Arg_List):-
(foreach(X,Arg_List) do nonvar(X) -> true ; false).

:- local variable(feature_list2,[]).
:- mode set_feature_list2(++).
set_feature_list2(V) :- setval(feature_list2, V).
get_feature_list2(V) :- getval(feature_list2, V).
