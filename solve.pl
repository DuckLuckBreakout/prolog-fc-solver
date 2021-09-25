
is_equal_sets(List1, List2) :- writeln('is_equal_sets(List1, List2)'),
	list_to_set(List1, Set1),
	list_to_set(List2, Set2),
	sort(Set1, SortedSet1),
	sort(Set2, SortedSet2),
	is_equal(SortedSet1, SortedSet2).

insert([H | T], [H | T2], Value) :- writeln('insert([H | T], [H | T2], Value)'),
	insert(T, T2, Value), !.

insert([H | []], [H, Value], Value) :- writeln('insert([H | []], [H, Value], Value)'), !.

insert([], [Value], Value) :- writeln('insert([], [Value], Value)'), !.

insert_to_head([H | T], Element, [Element, H | T]) :- writeln('insert_to_head([H | T], Element, [Element, H | T])'), !.

insert_to_head([], Element, [Element]).

set_value(Hardcode, Hardcode).

is_equal(Value, Value).

is_not_equal(Value, Value) :- writeln('is_not_equal(Value, Value)'), !, false.

is_not_equal(_, _).

columns_empty(1, 0) :- writeln('columns_empty(1, 0)'), !, false.

columns_empty(_, _).

delete_nth_element_from_list(List, N, ResultList) :- writeln('delete_nth_element_from_list(List, N, ResultList)'),
	delete_nth_element_from_list_internal(List, N, ResultList, 0).

delete_nth_element_from_list_internal([_ | T], Iteration, T, Iteration) :- writeln('delete_nth_element_from_list_internal([_ | T], Iteration, T, Iteration)'), !.

delete_nth_element_from_list_internal([H | T1], N, [H | T2], Iteration) :- writeln('delete_nth_element_from_list_internal([H | T1], N, [H | T2], Iteration)'),
	NSIteration is Iteration + 1,
	delete_nth_element_from_list_internal(T1, N, T2, NSIteration).

get_element(List, Index, Element) :- writeln('get_element(List, Index, Element)'),
   nth0(Index, List, Element).

get_element([], _, []).

get_element(_, _, []).

get_element_with_len(List, Index, Element, Len) :- writeln('get_element_with_len(List, Index, Element, Len)'),
	nth0(Index, List, Element),
	length(Element, Len).

get_element_with_len([], _, [], _).

get_element_with_len(_, _, [], _).

cnt_mod(A, B, Res) :- writeln('cnt_mod(A, B, Res)'),
	Res is A mod B.

replace(Index, List, Element, Result) :- writeln('replace(Index, List, Element, Result)'),
  nth0(Index, List, _, Res),
  nth0(Index, Result, Element, Res), !.

replace(Index, List, Element, Res) :- writeln('replace(Index, List, Element, Res)'),
	length(List, ListLength),
	Index >= ListLength,
	insert(List, Res, Element).

state_inside_state_machine(StateMachineList, [Dom, FreeCells, Field]) :- writeln('state_inside_state_machine(StateMachineList, [Dom, FreeCells, Field])'),
	make_lite_field_downset_snapshot(Field, FieldSnapshot),
	state_inside_state_machine_internal(StateMachineList, [Dom, FreeCells, FieldSnapshot]).

state_inside_state_machine_internal([[Dom, FreeCells, FieldSTM] | _], [Dom, FreeCells, LiteFieldSnapshot]) :- writeln('state_inside_state_machine_internal([[Dom, FreeCells, FieldSTM] | _], [Dom, FreeCells, LiteFieldSnapshot])'),
	make_lite_field_downset_snapshot(FieldSTM, FieldSnapshotSTM),
	is_equal_sets(FieldSnapshotSTM, LiteFieldSnapshot), !.

state_inside_state_machine_internal([_ | T], State) :- writeln('state_inside_state_machine_internal([_ | T], State)'),
	state_inside_state_machine_internal(T, State).

state_inside_state_machine_internal([], _) :- writeln('state_inside_state_machine_internal([], _)'), !, false.

stm_init(Result) :- writeln('stm_init(Result)'),
	set_value(Result, []).

stm_append_value_if_not_in_stm(Snapshot, State, SnapshotResult) :- writeln('stm_append_value_if_not_in_stm(Snapshot, State, SnapshotResult)'),
	not(state_inside_state_machine(Snapshot, State)), !,
	insert_to_head(Snapshot, State, SnapshotResult).

make_lite_field_downset_snapshot(Field, FieldSnapshot) :- writeln('make_lite_field_downset_snapshot(Field, FieldSnapshot)'), make_lite_field_downset_snapshot_internal(Field, FieldSnapshot, []).

make_lite_field_downset_snapshot_internal([[TopCard | ColumnTail] | FieldTail], FieldSnapshot, TempSnapshot) :- writeln('make_lite_field_downset_snapshot_internal([[TopCard | ColumnTail] | FieldTail], FieldSnapshot, TempSnapshot)'),
	length([TopCard | ColumnTail], N),
	insert_to_head(TempSnapshot, [N, TopCard], NSTempSnapshot),
	make_lite_field_downset_snapshot_internal(FieldTail, FieldSnapshot, NSTempSnapshot).

make_lite_field_downset_snapshot_internal([[] | FieldTail], FieldSnapshot, TempSnapshot) :- writeln('make_lite_field_downset_snapshot_internal([[] | FieldTail], FieldSnapshot, TempSnapshot)'),
	insert_to_head(TempSnapshot, [0, []], NSTempSnapshot),
	make_lite_field_downset_snapshot_internal(FieldTail, FieldSnapshot, NSTempSnapshot).

make_lite_field_downset_snapshot_internal([], FieldSnapshot, FieldSnapshot) :- writeln('make_lite_field_downset_snapshot_internal([], FieldSnapshot, FieldSnapshot)'), !.

generate_sorted_array_of_color(MaxValue, Color, Result) :- writeln('generate_sorted_array_of_color(MaxValue, Color, Result)'),
	generate_sorted_array_of_color_internal(MaxValue, Color, Result, [], 0).

getAllElements([],[]).

getAllElements([H|T], ElementsList) :- writeln('getAllElements([H|T], ElementsList)'), getAllElements(T, NewElementsList),
									   append(NewElementsList, H, ElementsList).

generate_sorted_array_of_color_internal(MaxValue, Color, Result, Temp, Iteration) :- writeln('generate_sorted_array_of_color_internal(MaxValue, Color, Result, Temp, Iteration)'),
	Iteration < MaxValue,
	insert(Temp, NextTemp, [Iteration, Color]),
	NextIteration is Iteration + 1,
	generate_sorted_array_of_color_internal(MaxValue, Color, Result, NextTemp, NextIteration), !.

generate_sorted_array_of_color_internal(Iteration, _, Result, Result, Iteration).

generate_field_internal(MaxValue, NumColor, Field, Temp, Iteration) :- writeln('generate_field_internal(MaxValue, NumColor, Field, Temp, Iteration)'),
	Iteration < NumColor,
	generate_sorted_array_of_color(MaxValue, Iteration, SortedResult),
	insert(Temp, NewTemp, SortedResult),
	NextIteration is Iteration + 1,
	generate_field_internal(MaxValue, NumColor, Field, NewTemp, NextIteration), !.

generate_field_internal(_, _, Field, Field, _).

throw_cards(Cards, RowsCount, TotalCards, Field) :- writeln('throw_cards(Cards, RowsCount, TotalCards, Field)'),
	throw_cards_internal(Cards, RowsCount, TotalCards, [], Field, 0).

throw_cards_internal([H | T], RowsCount, TotalCards, TempField, Field, Iteration) :- writeln('throw_cards_internal([H | T], RowsCount, TotalCards, TempField, Field, Iteration)'),
	Iteration < TotalCards,
	cnt_mod(Iteration, RowsCount, Index),
	get_element(TempField, Index, Row),
	insert(Row, NewRow, H),
	replace(Index, TempField, NewRow, NewTempField),
	NextIteration is Iteration + 1,
	throw_cards_internal(T, RowsCount, TotalCards, NewTempField, Field, NextIteration), !.

throw_cards_internal(_, _, _, Field, Field, _).

generate_field(MaxValue, NumColor, Field) :- writeln('generate_field(MaxValue, NumColor, Field)'),
	generate_field_internal(MaxValue, NumColor, AllCards, [], 0),
	getAllElements(AllCards, AllCardsList),
	random_permutation(AllCardsList, ShuffledCardList),
	RowsCount is NumColor * 2,
	TotalCards is NumColor * MaxValue,
	throw_cards(ShuffledCardList, RowsCount, TotalCards, Field).

generate_empty_free_cells(FreeCellsResult) :- writeln('generate_empty_free_cells(FreeCellsResult)'),
	set_value(FreeCellsResult, []).

generate_empty_dom(NumberOfDomItems, DomResult) :- writeln('generate_empty_dom(NumberOfDomItems, DomResult)'),
	generate_empty_list_of_lists(NumberOfDomItems, DomResult).

generate_empty_list_of_lists(NumberOfItems, ResultArray) :- writeln('generate_empty_list_of_lists(NumberOfItems, ResultArray)'),
	generate_empty_free_cells_internal(NumberOfItems, [], ResultArray, 0).

generate_empty_free_cells_internal(NumberOfItems, TempArray, ResultArray, Iteration) :- writeln('generate_empty_free_cells_internal(NumberOfItems, TempArray, ResultArray, Iteration)'),
	Iteration < NumberOfItems,
	NSIteration is Iteration + 1,
	insert(TempArray, NSTempArray, []),
	generate_empty_free_cells_internal(NumberOfItems, NSTempArray, ResultArray, NSIteration), !.

generate_empty_free_cells_internal(NumberOfItems, ResultArray, ResultArray, NumberOfItems).

get_top_card_from_nth_column(Field, N, H) :- writeln('get_top_card_from_nth_column(Field, N, H)'), get_element(Field, N, [H | _]).

get_top_card_from_nth_column_with_length(Field, N, H, Len) :- writeln('get_top_card_from_nth_column_with_length(Field, N, H, Len)'), get_element_with_len(Field, N, [H | _], Len).

pop_first_element([_ | T], T) :- writeln('pop_first_element([_ | T], T)'), !.

pop_first_element([], []) :- writeln('pop_first_element([], [])'), !.

remove_top_card_from_nth_column(Field, N, FieldResult) :- writeln('remove_top_card_from_nth_column(Field, N, FieldResult)'),
	get_element(Field, N, Column),
	pop_first_element(Column, ColumnResult),
	replace(N, Field, ColumnResult, FieldResult).

avalialbe_to_push_card_to_free_cells(ReservedFreeCellsCount, FreeCellsCount) :- writeln('avalialbe_to_push_card_to_free_cells(ReservedFreeCellsCount, FreeCellsCount)'), ReservedFreeCellsCount < FreeCellsCount.

move_card_to_free_cell_if_avaliable(Card, RowOfCard, Field, FreeCells, FreeCellsSize, ReservedCellsCount, FieldResult, FreeCellsResult, ReservedCellsCountResult) :- writeln('move_card_to_free_cell_if_avaliable(Card, RowOfCard, Field, FreeCells, FreeCellsSize, ReservedCellsCount, FieldResult, FreeCellsResult, ReservedCellsCountResult)'),
	avalialbe_to_push_card_to_free_cells(ReservedCellsCount, FreeCellsSize),
	insert(FreeCells, FreeCellsResult, Card),
	remove_top_card_from_nth_column(Field, RowOfCard, FieldResult), !,
	ReservedCellsCountResult is ReservedCellsCount + 1.

move_card_to_dom_if_avaliable(Card, Field, RowOfCard, Dom, MaxValue, FieldResult, DomResult) :- writeln('move_card_to_dom_if_avaliable(Card, Field, RowOfCard, Dom, MaxValue, FieldResult, DomResult)'),
	move_card_to_dom_if_avaliable_internal(Card, Field, RowOfCard, Dom, Dom, MaxValue, FieldResult, DomResult, 0).

avaliable_to_push_card_to_dom_column(Card, Column, MaxValue) :- writeln('avaliable_to_push_card_to_dom_column(Card, Column, MaxValue)'),
	MaxAvaliableValue is MaxValue - 1,
	avaliable_to_push_card_to_dom_column_internal(Card, Column, MaxAvaliableValue).

avaliable_to_push_card_to_dom_column_internal([MaxAvaliableValue, _], [], MaxAvaliableValue) :- writeln('avaliable_to_push_card_to_dom_column_internal([MaxAvaliableValue, _], [], MaxAvaliableValue)'),  !.

avaliable_to_push_card_to_dom_column_internal([0, Color], [[MaxAvaliableValue, Color] | []],  MaxAvaliableValue) :- writeln('avaliable_to_push_card_to_dom_column_internal([0, Color], [[MaxAvaliableValue, Color] | []],  MaxAvaliableValue)'),  !.

avaliable_to_push_card_to_dom_column_internal([Value, Color], [[TopCardValue, Color] | _],  _) :- writeln('avaliable_to_push_card_to_dom_column_internal([Value, Color], [[TopCardValue, Color] | _],  _)'),
	ValueValidaesTolayOver is TopCardValue + 1,
	is_equal(Value, ValueValidaesTolayOver).

move_card_to_dom_if_avaliable_internal(Card, Field, RowOfCard, Dom, [H | _], MaxValue, FieldResult, DomResult, Iteration) :- writeln('move_card_to_dom_if_avaliable_internal(Card, Field, RowOfCard, Dom, [H | _], MaxValue, FieldResult, DomResult, Iteration)'),
	avaliable_to_push_card_to_dom_column(Card, H, MaxValue),
	insert_to_head(H, Card, ColumnRes),
	replace(Iteration, Dom, ColumnRes, DomResult),
	remove_top_card_from_nth_column(Field, RowOfCard, FieldResult), !.

move_card_to_dom_if_avaliable_internal(Card, Field, RowOfCard, Dom, [_ | T], MaxValue, FieldResult, DomResult, Iteration) :- writeln('move_card_to_dom_if_avaliable_internal(Card, Field, RowOfCard, Dom, [_ | T], MaxValue, FieldResult, DomResult, Iteration)'),
	NSIteration is Iteration + 1,
	move_card_to_dom_if_avaliable_internal(Card, Field, RowOfCard, Dom, T, MaxValue, FieldResult, DomResult, NSIteration), !.

move_card_to_dom_if_avaliable_internal(_, Field, _, Dom, [], _, Field, Dom, _) :- writeln('move_card_to_dom_if_avaliable_internal(_, Field, _, Dom, [], _, Field, Dom, _)'), false.

move_card_to_field_from_free_cell_if_avaliable(Card, Field, FreeCells, NumberOfColumns, ReservedFreeCellsCount, FieldResult, FreeCellsResult, ReservedFreeCellsCountResult) :- writeln('move_card_to_field_from_free_cell_if_avaliable(Card, Field, FreeCells, NumberOfColumns, ReservedFreeCellsCount, FieldResult, FreeCellsResult, ReservedFreeCellsCountResult)'),
	move_card_to_field_some_column_if_avalialbe_card(Field, Card, NumberOfColumns, FieldResult),
	delete(FreeCells, Card, FreeCellsResult),
	ReservedFreeCellsCountResult is ReservedFreeCellsCount - 1.

move_card_to_dom_from_free_cell_if_avaliable(Card, Dom, FreeCells, ReservedFreeCellsCount, DomResult, FreeCellsResult, ReservedFreeCellsCountResult, MaxValue) :- writeln('move_card_to_dom_from_free_cell_if_avaliable(Card, Dom, FreeCells, ReservedFreeCellsCount, DomResult, FreeCellsResult, ReservedFreeCellsCountResult, MaxValue)'),
	move_card_to_dom_from_free_cell_if_avaliable_internal(Card, FreeCells, Dom, Dom, MaxValue, FreeCellsResult, DomResult, ReservedFreeCellsCount, ReservedFreeCellsCountResult, 0).

move_card_to_dom_from_free_cell_if_avaliable_internal(Card, FreeCells, Dom, [H | _], MaxValue, FreeCellsResult, DomResult, ReservedFreeCellsCount, ReservedFreeCellsCountResult, Iteration) :- writeln('move_card_to_dom_from_free_cell_if_avaliable_internal(Card, FreeCells, Dom, [H | _], MaxValue, FreeCellsResult, DomResult, ReservedFreeCellsCount, ReservedFreeCellsCountResult, Iteration)'),
	avaliable_to_push_card_to_dom_column(Card, H, MaxValue),
	insert_to_head(H, Card, ColumnRes),
	replace(Iteration, Dom, ColumnRes, DomResult),
	delete(FreeCells, Card, FreeCellsResult),
	ReservedFreeCellsCountResult is ReservedFreeCellsCount - 1, !.

move_card_to_dom_from_free_cell_if_avaliable_internal(Card, FreeCells, Dom, [_ | T], MaxValue, FreeCellsResult, DomResult, ReservedFreeCellsCount, ReservedFreeCellsCountResult, Iteration) :- writeln('move_card_to_dom_from_free_cell_if_avaliable_internal(Card, FreeCells, Dom, [_ | T], MaxValue, FreeCellsResult, DomResult, ReservedFreeCellsCount, ReservedFreeCellsCountResult, Iteration)'),
	NSIteration is Iteration + 1,
	move_card_to_dom_from_free_cell_if_avaliable_internal(Card, FreeCells, Dom, T, MaxValue, FreeCellsResult, DomResult, ReservedFreeCellsCount, ReservedFreeCellsCountResult, NSIteration), !.

move_card_to_dom_from_free_cell_if_avaliable_internal(_, Field, Dom, [], _, Field, Dom, _, _) :- writeln('move_card_to_dom_from_free_cell_if_avaliable_internal(_, Field, Dom, [], _, Field, Dom, _, _)'), false.

avaliable_to_push_card_to_field_column(_, N, N) :- writeln('avaliable_to_push_card_to_field_column(_, N, N)'), !, false.

avaliable_to_push_card_to_field_column(Field, CardN, ColumnN) :- writeln('avaliable_to_push_card_to_field_column(Field, CardN, ColumnN)'),
	get_element(Field, ColumnN, Column),
	length(Column, ColumnLen),
	get_top_card_from_nth_column_with_length(Field, CardN, Card, CardColumnLen), !,
	avaliable_to_push_card_to_field_column_internal_with_len(Card, Column, CardColumnLen, ColumnLen).

avaliable_to_push_card_to_field_column_card(Field, Card, ColumnN) :- writeln('avaliable_to_push_card_to_field_column_card(Field, Card, ColumnN)'),
	get_element(Field, ColumnN, Column), !,
	avaliable_to_push_card_to_field_column_internal(Card, Column).

avaliable_to_push_card_to_field_column_internal(_, []) :- writeln('avaliable_to_push_card_to_field_column_internal(_, [])'),  !.

avaliable_to_push_card_to_field_column_internal([Value, Color], [[TopCardValue, TopCardColor] | _]) :- writeln('avaliable_to_push_card_to_field_column_internal([Value, Color], [[TopCardValue, TopCardColor] | _])'),
	is_not_equal(Color, TopCardColor),
	ValueValidaesTolayOver is TopCardValue - 1,
	is_equal(Value, ValueValidaesTolayOver).

avaliable_to_push_card_to_field_column_internal_with_len([Value, Color], [[TopCardValue, TopCardColor] | _], CardColumnLen, ColumnLen) :- writeln('avaliable_to_push_card_to_field_column_internal_with_len([Value, Color], [[TopCardValue, TopCardColor] | _], CardColumnLen, ColumnLen)'),
	columns_empty(CardColumnLen, ColumnLen),
	is_not_equal(Color, TopCardColor),
	ValueValidaesTolayOver is TopCardValue - 1,
	is_equal(Value, ValueValidaesTolayOver).

move_card_to_field_column(Field, N, ColumnN, FieldResult) :- writeln('move_card_to_field_column(Field, N, ColumnN, FieldResult)'),
	get_top_card_from_nth_column(Field, N, Card),
	remove_top_card_from_nth_column(Field, N, TempFieldResult),
	get_element(TempFieldResult, ColumnN, Column),
	   insert_to_head(Column, Card, UpdatedColum),
	replace(ColumnN, TempFieldResult, UpdatedColum, FieldResult), !.

add_card_to_field_column(Field, Card, ColumnN, FieldResult) :- writeln('add_card_to_field_column(Field, Card, ColumnN, FieldResult)'),
	get_element(Field, ColumnN, Column),
	insert_to_head(Column, Card, ColumnResult),
	replace(ColumnN, Field, ColumnResult, FieldResult), !.

find_avaliable_column_to_push(Field, NumberOfColumns, N, FoundedColumn) :- writeln('find_avaliable_column_to_push(Field, NumberOfColumns, N, FoundedColumn)'),
	find_avaliable_column_to_push_internal(Field, NumberOfColumns, N, FoundedColumn, 0).

find_avaliable_column_to_push_internal(_, NumberOfColumns, _, _, NumberOfColumns) :- writeln('find_avaliable_column_to_push_internal(_, NumberOfColumns, _, _, NumberOfColumns)'),
	!, false.

find_avaliable_column_to_push_internal(Field, _, N, Iteration, Iteration) :- writeln('find_avaliable_column_to_push_internal(Field, _, N, Iteration, Iteration)'),
	avaliable_to_push_card_to_field_column(Field, N, Iteration).

find_avaliable_column_to_push_internal(Field, NumberOfColumns, N, FoundedItem, Iteration) :- writeln('find_avaliable_column_to_push_internal(Field, NumberOfColumns, N, FoundedItem, Iteration)'),
	NSIteration is Iteration + 1,
	find_avaliable_column_to_push_internal(Field, NumberOfColumns, N, FoundedItem, NSIteration).

find_avaliable_column_to_push_card(Field, NumberOfColumns, Card, FoundedColumn) :- writeln('find_avaliable_column_to_push_card(Field, NumberOfColumns, Card, FoundedColumn)'),
	find_avaliable_column_to_push_internal_card(Field, NumberOfColumns, Card, FoundedColumn, 0).

find_avaliable_column_to_push_internal_card(_, NumberOfColumns, _, _, NumberOfColumns) :- writeln('find_avaliable_column_to_push_internal_card(_, NumberOfColumns, _, _, NumberOfColumns)'),
	!, false.

find_avaliable_column_to_push_internal_card(Field, _, Card, Iteration, Iteration) :- writeln('find_avaliable_column_to_push_internal_card(Field, _, Card, Iteration, Iteration)'),
	avaliable_to_push_card_to_field_column_card(Field, Card, Iteration).

find_avaliable_column_to_push_internal_card(Field, NumberOfColumns, Card, FoundedItem, Iteration) :- writeln('find_avaliable_column_to_push_internal_card(Field, NumberOfColumns, Card, FoundedItem, Iteration)'),
	NSIteration is Iteration + 1,
	find_avaliable_column_to_push_internal_card(Field, NumberOfColumns, Card, FoundedItem, NSIteration).

move_card_to_field_some_column_if_avalialbe(Field, NumberOfColumns, N, FieldResult) :- writeln('move_card_to_field_some_column_if_avalialbe(Field, NumberOfColumns, N, FieldResult)'),
	find_avaliable_column_to_push(Field, NumberOfColumns, N, ColumnNumber), !,
	move_card_to_field_column(Field, N, ColumnNumber, FieldResult).

move_card_to_field_some_column_if_avalialbe_card(Field, Card, NumberOfColumns, FieldResult) :- writeln('move_card_to_field_some_column_if_avalialbe_card(Field, Card, NumberOfColumns, FieldResult)'),
	find_avaliable_column_to_push_card(Field, NumberOfColumns, Card, ColumnNumber),
	add_card_to_field_column(Field, Card, ColumnNumber, FieldResult).

move_card_to_available_field_column(Card, Field, FieldResult) :- writeln('move_card_to_available_field_column(Card, Field, FieldResult)'),
	move_card_to_available_field_column_internal(Card, Field, FieldResult).

solve(MaxValue, ColorsCount, Solution) :- writeln('solve(MaxValue, ColorsCount, Solution)'),
	FreeCellsSize is ColorsCount,
	ReservedCellsCount is 0,
	NumberOfColumns is ColorsCount * 2,
	generate_field(MaxValue, ColorsCount, Field),
	generate_empty_free_cells(FreeCells),
	generate_empty_dom(ColorsCount, Dom),
	stm_init(State),
	stm_append_value_if_not_in_stm(State, [Dom, FreeCells, Field], States),
	make_move(Field, MaxValue, NumberOfColumns, FreeCells, Dom, FreeCellsSize, ReservedCellsCount, States, Solution).

solve_mock(Solution) :- writeln('solve_mock(Solution)'),
	MaxValue is 10,
	ColorsCount is 1,
	FreeCellsSize is ColorsCount,
	ReservedCellsCount is 0,
	NumberOfColumns is ColorsCount * 2,
	set_value(Field,
	[[[3, 0], [2, 0], [1, 0], [9, 0], [4, 0]], [[8, 0], [7, 0], [5, 0], [0, 0], [6, 0]]]
	),
	generate_empty_free_cells(FreeCells),
	generate_empty_dom(ColorsCount, Dom),
	stm_init(State),
	stm_append_value_if_not_in_stm(State, [Dom, FreeCells, Field], States),
	make_move(Field, MaxValue, NumberOfColumns, FreeCells, Dom, FreeCellsSize, ReservedCellsCount, States, Solution).


create_solution(Field, MaxValue, NumberOfColors, Solution) :- writeln('create_solution(Field, MaxValue, NumberOfColors, Solution)'),
	generate_empty_free_cells(FreeCells),
	NumberOfColumns is NumberOfColors * 2,
	generate_empty_dom(NumberOfColors, Dom),
	stm_init(State),
	stm_append_value_if_not_in_stm(State, [Dom, FreeCells, Field], States),
	make_move(Field, MaxValue, NumberOfColumns, FreeCells, Dom, NumberOfColors, 0, States, Solution).

make_move(Field, _, _, _, _, _, 0, Solution, Solution) :- writeln('make_move(Field, _, _, _, _, _, 0, Solution, Solution)'),
	field_is_empty(Field), !.

make_move(Field, MaxValue, NumberOfColumns, FreeCells, Dom, FreeCellsSize, ReservedFreeCells, Snapshots, Solution) :- writeln('make_move(Field, MaxValue, NumberOfColumns, FreeCells, Dom, FreeCellsSize, ReservedFreeCells, Snapshots, Solution)'),
	get_top_card(Field, Card, RowOfCard),
	move_card_to_dom_if_avaliable(Card, Field, RowOfCard, Dom, MaxValue, FieldResult, DomResult),
	stm_append_value_if_not_in_stm(Snapshots, [DomResult, FreeCells, FieldResult], NSSnapshot),
	make_move(FieldResult, MaxValue, NumberOfColumns, FreeCells, DomResult, FreeCellsSize, ReservedFreeCells, NSSnapshot, Solution), !.

make_move(Field, MaxValue, NumberOfColumns, FreeCells, Dom, FreeCellsSize, ReservedFreeCells, Snapshots, Solution) :- writeln('make_move(Field, MaxValue, NumberOfColumns, FreeCells, Dom, FreeCellsSize, ReservedFreeCells, Snapshots, Solution)'),
	process_free_cell_card(FreeCells, Card),
	move_card_to_dom_from_free_cell_if_avaliable(Card, Dom, FreeCells, ReservedFreeCells, DomResult, FreeCellsResult, ReservedFreeCellsCountResult, MaxValue),
	stm_append_value_if_not_in_stm(Snapshots, [DomResult, FreeCellsResult, Field], NSSnapshot),
	make_move(Field, MaxValue, NumberOfColumns, FreeCellsResult, DomResult, FreeCellsSize, ReservedFreeCellsCountResult, NSSnapshot, Solution), !.

make_move(Field, MaxValue, NumberOfColumns, FreeCells, Dom, FreeCellsSize, ReservedFreeCells, Snapshots, Solution) :- writeln('make_move(Field, MaxValue, NumberOfColumns, FreeCells, Dom, FreeCellsSize, ReservedFreeCells, Snapshots, Solution)'),
	process_free_cell_card(FreeCells, Card),
	move_card_to_field_from_free_cell_if_avaliable(Card, Field, FreeCells, NumberOfColumns, ReservedFreeCells, FieldResult, FreeCellsResult, ReservedFreeCellsCountResult),
	stm_append_value_if_not_in_stm(Snapshots, [Dom, FreeCellsResult, FieldResult], NSSnapshot),
	make_move(FieldResult, MaxValue, NumberOfColumns, FreeCellsResult, Dom, FreeCellsSize, ReservedFreeCellsCountResult, NSSnapshot, Solution), !.

make_move(Field, MaxValue, NumberOfColumns, FreeCells, Dom, FreeCellsSize, ReservedFreeCells, Snapshots, Solution) :- writeln('make_move(Field, MaxValue, NumberOfColumns, FreeCells, Dom, FreeCellsSize, ReservedFreeCells, Snapshots, Solution)'),
	get_top_card(Field, _, RowOfCard),
	move_card_to_field_some_column_if_avalialbe(Field, NumberOfColumns, RowOfCard, FieldResult),
	stm_append_value_if_not_in_stm(Snapshots, [Dom, FreeCells, FieldResult], NSSnapshot),
	make_move(FieldResult, MaxValue, NumberOfColumns, FreeCells, Dom, FreeCellsSize, ReservedFreeCells, NSSnapshot, Solution), !.

make_move(Field, MaxValue, NumberOfColumns, FreeCells, Dom, FreeCellsSize, ReservedFreeCells, Snapshots, Solution) :- writeln('make_move(Field, MaxValue, NumberOfColumns, FreeCells, Dom, FreeCellsSize, ReservedFreeCells, Snapshots, Solution)'),
	get_top_card(Field, Card, RowOfCard),
	move_card_to_free_cell_if_avaliable(Card, RowOfCard, Field, FreeCells, FreeCellsSize, ReservedFreeCells, FieldResult, FreeCellsResult, ReservedCellsCountResult),
	stm_append_value_if_not_in_stm(Snapshots, [Dom, FreeCellsResult, FieldResult], NSSnapshot),
	make_move(FieldResult, MaxValue, NumberOfColumns, FreeCellsResult, Dom, FreeCellsSize, ReservedCellsCountResult, NSSnapshot, Solution), !.

get_top_card(Field, TopCard, CardRow) :- writeln('get_top_card(Field, TopCard, CardRow)'),
	get_top_card_internal(Field, TopCard, CardRow, 0).

get_top_card_internal([[TopCard | _] | _], TopCard, Itaration, Itaration).

get_top_card_internal([ _ | T], TopCard, CardRow, Itaration) :- writeln('get_top_card_internal([ _ | T], TopCard, CardRow, Itaration)'),
	NSIteration is Itaration + 1,
	get_top_card_internal(T, TopCard, CardRow, NSIteration).

process_free_cell_card(FreeCells, Card) :- writeln('process_free_cell_card(FreeCells, Card)'),
	process_free_cell_card_internal(FreeCells, Card).

process_free_cell_card_internal([H | _], H).

process_free_cell_card_internal([_ | T], Card) :- writeln('process_free_cell_card_internal([_ | T], Card)'),
	process_free_cell_card_internal(T, Card).

field_is_empty([[] | T]) :- writeln('field_is_empty([[] | T])'),
	field_is_empty(T), !.

field_is_empty([[]]).
