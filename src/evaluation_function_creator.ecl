:-module(evaluation_function_creator).


:-use_module(listut).
:-use_module(match_info).
:-use_module(game_description).

:-export(keep_x_best/2).


keep_x_best(List,Number):-
	(
	param(List),
	for(I,1,Number) do
		nth1(I,List,Elem),
		get_final_term_list(List2),
		append([Elem],List2,Final_List),
		set_final_term_list(Final_List)
	).
	
evaluate(State,Eval):-
	get_final_term_list(NList),
	get_expected_score(Score),
	set_eval(Score),
	(
	param(State),
	foreach(Term,NList) do 
		arg(1,Term,Feature),
		calculate_value(Feature,State,Value),
		arg(2,Term,Weight),
		return_product(Value,Weight,Result),
		
		get_eval(Evaluation),
		return_sum(Result,Evaluation,Evaluated),
		set_eval(Evaluated)
	),
	get_eval(Eval)
	.	
		
		
		
calculate_value(Feature,State,Value):-
	(headcutter(Feature,Tail,Head) ->
		(
		findall(Head,true(Head,State),List1) ->
			length(List1,Value1)
		;
			Value1 is 0
		),
		(
		findall(Tail,true(Tail,State),List2) ->
			length(List2,Value2)
		;
			Value2 is 0
		),
		Value is Value1 - Value2
	
	
	;	
		(
		findall(Feature,true(Feature,State),List) ->
			length(List,Value)
		;
			Value is 0
		)
	)
	.
			
return_product(X,Y,Z):-
	Z is X * Y.
		
return_sum(X,Y,Z):-
	Z is X + Y.
		
headcutter([H|T],M,Score):-
	H = Score, T = M.
		
		