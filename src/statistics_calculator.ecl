:-module(statistics_calculator).

:-use_module(game_description).
:-use_module(match_info).
:-use_module(listut).

:-export(make_stat_terms/0).

% featurestat(feature_name,subsequneceID,state,value_of_feature,Subsequence_score)
make_stat_terms:-
	get_feature_list(Feature_List),
	get_seq_list(Seq_List),
	(
	param(Seq_List),
	foreach(Feature,Feature_List) do
		set_sumval(0),
		set_sumsc(0),
		set_counterst(0),
		set_sumvaldiff(0),
		set_sumscdiff(0),
		set_sum_val_score_prod(0),
		set_sumsv(0),
		set_countersv(0),
		
		functor(Feature_stat_term,featurestat,4),
		arg(1,Feature_stat_term,Feature),
		
		per_subsequence(Seq_List,Feature),
		
		get_counterst(Counter),
		
		get_sumval(SumVal),
		return_mean(SumVal,Counter,MeanVal),    % find the mean of Value across all states
		
		get_sumsc(SumSc),
		return_mean(SumSc,Counter,MeanSc),    %find the mean of Score across all states
		
		get_expected_score(Expected_Score),
		return_sum(SumSc,Expected_Score,New_Expected_Score),
		set_expected_score(New_Expected_Score),
		
		per_subsequence2(Seq_List,Feature,MeanSc,MeanVal),
		
		get_sum_val_score_prod(AB),
		get_sumvaldiff(A),
		get_sumscdiff(B),
		return_correlation(A,B,AB,Corr),
		return_variance(A,Counter,TV),
		
		get_countersv(CounterSc),
		get_sumsv(SumSV),
		return_mean(SumSV,CounterSc,SV),
		
		return_stability(TV,SV,Stab),
		
		
		arg(2,Feature_stat_term,Corr),
		arg(3,Feature_stat_term,Stab),
		
		get_feature_stat_term_list(F_stat_list),
		append([Feature_stat_term],F_stat_list,New_F_stat_list),
		set_feature_stat_term_list(New_F_stat_list)
	)
	
	.


per_subsequence(Seq_List,Feature):-
	(
	param(Feature),
	foreach(Subseq_List,Seq_List) do
		headcutter(Subseq_List,N_Subseq_List,Score), % remove score from subsequence state list
		
		set_counterstsub(0),
		set_sumvaldiffsub(0),     % set all subsequence variables to 0
		set_sumvaldiffsq(0),
		
		per_state(N_Subseq_List,Feature,Score),
		
		get_counterstsub(Number_of_seq),
		get_sumvaldiffsub(Sequence_value),
		return_mean(Sequence_value,Number_of_seq,Meansub), % find the mean of Value across the subsequence
		
		per_state3(N_Subseq_List,Feature,Meansub),
		
		get_sumvaldiffsq(Valsum),
		return_variance(Valsum,Number_of_seq,SV),    % find the variance of value in this subsequence
		
		get_sumsv(VarianceSum),
		return_sum(VarianceSum,SV,T_SV),     % calculate the sum of variances of substate
		set_sumsv(T_SV),
		
		get_countersv(Counter3),
		increment(Counter3,New_Counter3),  % count the subsequences
		set_countersv(New_Counter3)
		
		
	).

per_subsequence2(Seq_List,Feature,MeanSc,MeanVal):-
	(
	param(MeanSc),
	param(MeanVal),
	param(Feature),
	foreach(Subseq_List,Seq_List) do
		headcutter(Subseq_List,N_Subseq_List,Score),
		per_state2(N_Subseq_List,Feature,Score,MeanSc,MeanVal)
	).

per_state(N_Subseq_List,Feature,Score):-
	(
	param(Feature),
	param(Score),
	foreach(State,N_Subseq_List) do
		calculate_value(Feature,State,Value),
		
		get_sumval(Sumval),
		return_sum(Sumval,Value,New_Sumval),   % Sum of feature values across all states
		set_sumval(New_Sumval),
		
		get_sumsc(Sumsc),
		return_sum(Sumsc,Score,New_Sumsc),    % sum of feature score across all states
		set_sumsc(New_Sumsc),
		
		get_counterst(Counter),
		increment(Counter,New_Counter),       % number of all states
		set_counterst(New_Counter),
		
		get_sumvaldiffsub(SumVal2),
		return_sum(SumVal2,Value,New_SumVal2),   % Sum of feature values in all states of the substate
		set_sumvaldiffsub(New_SumVal2),
		
		get_counterstsub(Counter2),
		increment(Counter2,New_Counter2),		%number states in substate
		set_counterstsub(New_Counter2)
		
		
	).
	
per_state2(N_Subseq_List,Feature,Score,MeanSc,MeanVal):-
	(
	param(MeanSc),
	param(MeanVal),
	param(Feature),
	param(Score),
	foreach(State,N_Subseq_List) do
		calculate_value(Feature,State,Value),
		
		return_diff(Value,MeanVal,ValueDiff),
		return_square(ValueDiff,ValueDiff_Sq), % calculate (Value-meanValue)^2
		
		get_sumvaldiff(SqValue_Sum),
		return_sum(ValueDiff_Sq,SqValue_Sum,New_SqValue_Sum),  % calculate the sum of (Value-meanValue)^2 for all states
		set_sumvaldiff(New_SqValue_Sum),
		
		return_diff(Score,MeanSc,ScoreDiff),
		return_square(ScoreDiff,ScoreDiff_Sq), % calculate (Score-meanScore)^2
		
		get_sumscdiff(SqSc_Sum),
		return_sum(ScoreDiff_Sq,SqSc_Sum,New_SqSc_Sum), % calculate the sum of (Score-meanScore)^2 across all states
		set_sumscdiff(New_SqSc_Sum),
		
		return_product(ScoreDiff,ValueDiff,Product_Value_Score), % calculate ( (Value-meanValue)^2 * (Score-meanScore)^2 ) 
		
		get_sum_val_score_prod(Sum_Prod),
		return_sum(Product_Value_Score,Sum_Prod,New_Sum_Prod), % calculate the sum of ( (Value-meanValue)^2 * (Score-meanScore)^2 )  across all states
		set_sum_val_score_prod(New_Sum_Prod)
		
		
		
	).
	
per_state3(N_Subseq_List,Feature,Mean):-
	(
	param(Mean),
	param(Feature),
	foreach(State,N_Subseq_List) do
		calculate_value(Feature,State,Value),
		
		return_diff(Value,Mean,ValueDiff),    % calculate (Value - meanValue)^2
		return_square(ValueDiff,SqValuediff),
		
		get_sumvaldiffsq(V),
		return_sum(V,SqValuediff,New_V),       % calculate the sum of (Value - meanValue)^2 across all states of the subsequence
		set_sumvaldiffsq(New_V)
		
		
	).


return_stability(TV,SV,Tvar):-
	(TV \== 0.0 ->
		X is 10 * SV,
		Y is X + TV,
		Tvar is TV / Y
	;
		Tvar = 0
	).

return_variance(A,B,Var):-
	Var is A / B.

return_correlation(A,B,AB,Corr):-
	X is A + B,
	sqrt(X,Y),
	Corr is AB / Y.
	
return_product(X,Y,Z):-
	Z is X * Y.

return_square(X,Y):-
	Y is X ^ 2.

return_diff(X,Y,Z):-
	Z is X - Y .

return_sum(X,Y,Z):-
	Z is X + Y.
	
return_mean(Summed_Data,Number_of_Data,Mean):-
	Mean is Summed_Data / Number_of_Data .
	

increment(X,Y):-
	Y is X + 1.


calculate_value(Feature,State,Value):-
	(
	findall(Feature,true(Feature,State),List) ->
		length(List,Value)
	;
		Value is 0
	)
	.
	
	
	
headcutter([H|T],M,Score):-
	H = Score, T = M.
	