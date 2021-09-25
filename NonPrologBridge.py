import json
from Card import *
import numpy as np
from Constants import *


def reverse(array):
    copy = array
    copy.reverse()
    return copy

def map_raw_array_to_cards_array(raw_array):
    return [Card(element) for element in raw_array]

def map_raw_matirx_to_cards_matrix(raw_matrix):
    return [reverse(map_raw_array_to_cards_array(row)) for row in raw_matrix]




def map_raw_array_to_table_cards_array(raw_array):
    result = []
    for element in raw_array:
        card = Card(element)
        card.value += 2
        result.append(card)
    return result

def map_raw_matirx_to_table_cards_matrix(raw_matrix):
    return [reverse(map_raw_array_to_table_cards_array(row)) for row in raw_matrix]

def _print_transposed(matrix):
    array = []
    for row in matrix:
        array.append(np.array(row))
    array = np.array(array).transpose()
    for row in array:
        for card in row:
            card_string = str(card)
            print(f"{card_string:>14}", end='')
        print()

def fill_to_matrix_with_empty_cards(matrix):
    len_count_array = []
    for row in matrix:
        len_count_array.append(len(row))
    max_len = max(len_count_array)
    for row in range(len(matrix)):
        if len(matrix[row]) < max_len:
            for _ in range(max_len - len(matrix[row])):
                matrix[row].append(Card([-1, -1]))
    return matrix


class StatePrinter:
    raw_string = str

    def __init__(self, raw_string: str):
        self.raw_string = raw_string
        raw_state = json.loads(self.raw_string)
        raw_dom = raw_state[0]
        raw_free_cells = raw_state[1]
        raw_field = raw_state[2]

        config = SingletonConfig()
        config.update_columns_in_field(len(raw_field))
        max_depth = 0
        for column in raw_field:
            if len(column) > max_depth:
                max_depth = len(column)
        config.update_rows_in_column(max_depth)
        config.update_free_cells_len(len(raw_dom))
        config.update_dom_len(len(raw_dom))

        self.dom = fill_to_matrix_with_empty_cards(map_raw_matirx_to_table_cards_matrix(raw_dom))
        self.field = fill_to_matrix_with_empty_cards(map_raw_matirx_to_table_cards_matrix(raw_field))
        self.free_cells = map_raw_array_to_table_cards_array(raw_free_cells)

    def print(self):
        print(FColors.TEXT + "Free cells:")
        for card in self.free_cells:
            card_string = str(card)
            print(f"{card_string:>14}", end='')
        print()
        print(FColors.TEXT + "Dom:")
        _print_transposed(self.dom)
        print(FColors.TEXT + "Field:")
        _print_transposed(self.field)

class TrustedSolutionPrinter:
    raw_string = str
    __raw_solution = []
    solution_length = int
    step_by = int
    last_n = int
    def __init__(self, raw_string: str, step_by: int = 5, last_n: int = None):
        self.raw_string = raw_string
        raw_solution = json.loads(self.raw_string)
        raw_solution = reverse(raw_solution)
        self.__raw_solution = raw_solution
        self.solution_length = len(raw_solution)
        self.step_by = step_by
        if last_n:
            last_n_states = self.__raw_solution[-last_n:]
            first_state = self.__raw_solution[0]
            self.__raw_solution = [first_state] + last_n_states

    def get_raw_solution(self):
        return self.__raw_solution

    def print(self):
        print(f"Solution length: {self.solution_length}")
        i = 0
        need_to_force_print_last_state = True
        while i < len(self.__raw_solution):
            state = self.__raw_solution[i]
            self.__print_state(state)
            # input()
            if i == (len(self.__raw_solution) - 1):
                need_to_force_print_last_state = False
            i += self.step_by

        if need_to_force_print_last_state:
            i = len(self.__raw_solution) - 1
            state = self.__raw_solution[i]
            self.__print_state(state)




    def __print_state(self, state):
        printer = StatePrinter(str(state))
        printer.print()
        print("==========================================================")


if __name__ == "__main__":
    solution = input()
    printer = TrustedSolutionPrinter(solution)
    printer.print()





raw_states = '''
[[[]], [[8, 0]], [[[0, 0], [4, 0], [7, 0], [3, 0]], [[6, 0], [9, 0], [1, 0], [2, 0], [5, 0]]]];
[[[]], [[6, 0]], [[[8, 0], [0, 0], [4, 0], [7, 0], [3, 0]], [[9, 0], [1, 0], [2, 0], [5, 0]]]];
[[[[9, 0]]], [[6, 0]], [[[8, 0], [0, 0], [4, 0], [7, 0], [3, 0]], [[1, 0], [2, 0], [5, 0]]]];
'''

# raw_states = raw_states.split(';')[:-1]
# for raw_state in raw_states:
#     state = StatePrinter(raw_state)
#     state.print()
#     print("==========================================================")
#     input()


