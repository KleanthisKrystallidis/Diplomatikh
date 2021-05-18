:-module(test).

:-use_module(evaluation_function_creator).
:-use_module(listut).
:-use_module(game_description).
:-use_module(match_info).

:-export(alpha_beta/7).


alpha_beta(Role,0,State,_Alpha,_Beta,_NoMove,Value) :- 
	(terminal(State) ->
		goal(Role,Value,State)
	;
		evaluate(State,Value)
	).

alpha_beta(Role,D,State,Alpha,Beta,Move,Value) :- 
   D > 0, 
   moves(Role,State,Moves),
   Alpha1 is -Beta, % max/min
   Beta1 is -Alpha,
   D1 is D-1, 
   evaluate_and_choose(Role,Moves,State,D1,Alpha1,Beta1,nil,(Move,Value)).

evaluate_and_choose(Role,[Move|Moves],State,D,Alpha,Beta,Record,BestMove) :-
	get_ene_role(Enemy),
	opponent_role(Role,OpPlayer),
	(Enemy == Role ->
		reverse_list(Move,CMove)
	;
		CMove = Move
	),
	update_current_state2(Role,CMove,State1),
	alpha_beta(OpPlayer,D,State1,Alpha,Beta,_OtherMove,Value),
	set_current_state(State),
	Value1 is -Value,
	cutoff(Role,CMove,Value1,D,Alpha,Beta,Moves,State,Record,BestMove).
   
evaluate_and_choose(_Role,[],_Position,_D,Alpha,_Beta,Move,(Move,Alpha)).

cutoff(_Role,Move,Value,_D,_Alpha,Beta,_Moves,_Position,_Record,(Move,Value)) :- 
   Value >= Beta, !.
cutoff(Role,Move,Value,D,Alpha,Beta,Moves,State,_Record,BestMove) :- 
   Alpha < Value, Value < Beta, !, 
   evaluate_and_choose(Role,Moves,State,D,Value,Beta,Move,BestMove).
cutoff(Role,_Move,Value,D,Alpha,Beta,Moves,State,Record,BestMove) :- 
   Value =< Alpha, !, 
   evaluate_and_choose(Role,Moves,State,D,Alpha,Beta,Record,BestMove).


opponent_role(OurRole,OpRole):-
roles(Roles),
length(Roles,Len),
(
param(OpRole),
param(OurRole),
param(Roles),
	for(I,1,Len) do 
	nth1(I,Roles,PoRole),
	(OurRole \= PoRole ->
		OpRole = PoRole
	;
	true
	)
).	

moves(Role,State,Moves):-
	opponent_role(Role,OpRole),
	findall(MoveM,legal(Role,MoveM,State),MovesMy),
	findall(MoveO,legal(OpRole,MoveO,State),MovesOp),
	pairs(MovesMy,MovesOp,Moves).

pairs(Xs, Ys, Zs) :-

    (
        foreach(X,Xs),
        fromto(Zs, Zs4, Zs1, []),
        param(Ys)
    do
        (
            foreach(Y,Ys),
            fromto(Zs4, Zs3, Zs2, Zs1),
            param(X)
        do
            Zs3 = [[X,Y]|Zs2]
        )
    ).
	
update_current_state2(Role,Moves, CurrentState) :-
	get_current_state(LastState),
	(Moves\=[] ->
		does(Role, _OurMove, Moves,_C_Moves), !,
		state_update(LastState, Moves, CurrentState),
		set_current_state(CurrentState)
	;
		% this is the case for the first play-message (no prior moves)
		CurrentState=LastState
	).
	
reverse_list(List,RList):-
	nth1(1,List,H),
	nth1(2,List,T),
	append([T],[H],RList).
	
