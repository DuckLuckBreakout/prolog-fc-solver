import functools
import random

import pygame
from pyswip import Prolog
from NonPrologBridge import *
from pygame.locals import *


cards_old = {

}

cards_now = {

}


class Dom:
    fields = []
    cords = []

    def move(self, x, y):
        for field in self.fields:
            field.move(x, y)

    def draw(self):
        for field in self.fields:
            field.draw()

class DomField:
    def __init__(self, i, x, y, screen):
        self.screen = screen
        self.i = i
        self.rect = pygame.Rect(x - config.card_size['width'] // 2, y - config.card_size['height'] // 2,  config.card_size['width'], config.card_size['height'])
        self.text_surface_object = pygame.font.SysFont('Comic Sans MS', 13).render('', False, (0, 0, 0))

    def move(self, x, y):
        self.rect.move_ip(x, y)

    def draw(self):
         pygame.draw.rect(self.screen, GREEN, self.rect, int(config.card_size['width']), 3)
         text_rect = self.text_surface_object.get_rect(center=self.rect.center)
         self.screen.blit(self.text_surface_object, text_rect)


class FreeCells:
    fields = []
    cords = []

    def __init__(self, screen):
        self.screen = screen

    def move(self, x, y):
        for field in self.fields:
            field.move(x, y)

    def draw(self, ignore=None):
        for field in self.fields:
            field.draw()

    def update(self, solution):
        i = 0
        card_id = 0
        self.fields = []
        for column in solution[1]:
            row_i = 0
            x = (config.card_size['width'] // 2 + config.step) + (config.card_size['width'] + config.step) * i + int(config.step * 0.75)
            y = config.step + config.card_size['height'] // 2 + config.card_size['height'] + config.step + config.step * row_i
            for row in reverse(column):
                y = config.step + config.card_size['height'] // 2 + config.card_size['height'] + (config.card_size['height'] // 8) * (row_i + 1)
                card = FieldField(card_id, x, y, self.screen, Card(row))
                # cards[str(card)] = [x, y]
                self.fields.append(card)
                card_id += 1
                row_i += 1
            i += 1

class FreeCellsField:
    def __init__(self, i, x, y, screen):
        self.screen = screen
        self.i = i
        self.rect = pygame.Rect(x - config.card_size['width'] // 2, y - config.card_size['height'] // 2,  config.card_size['width'], config.card_size['height'])
        self.text_surface_object = pygame.font.SysFont('Comic Sans MS', 13).render('', False, (0, 0, 0))

    def move(self, x, y):
        self.rect.move_ip(x, y)

    def draw(self):
         pygame.draw.rect(self.screen, GREEN, self.rect, int(config.card_size['width']), 3)
         text_rect = self.text_surface_object.get_rect(center=self.rect.center)
         self.screen.blit(self.text_surface_object, text_rect)


class StepField:
    def __init__(self, i, x, y, screen, step, max_step):
        self.screen = screen
        self.i = i
        self.rect = pygame.Rect(x, y,  50, 50)
        self.text_surface_object = pygame.font.SysFont('Comic Sans MS', 13).render(f'{step}/{max_step}', True, WHITE)

    def draw(self):
         pygame.draw.rect(self.screen, GREEN_DARK, self.rect, int(config.card_size['width']), 3)
         text_rect = self.text_surface_object.get_rect(center=self.rect.center)
         self.screen.blit(self.text_surface_object, text_rect)

class Field:
    fields = []
    dom = []
    free_cells = []
    old_fields = []
    old_dom = []
    old_free_cells = []
    old_data = {}

    def __init__(self, screen):
        self.screen = screen

    def move(self, x, y):
        for field in self.fields:
            field.move(x, y)


    def draw(self, ignore=None):
        for field in self.dom:
            if ignore and field.value == ignore.value and field.color == ignore.color:
                continue
            field.draw()
        for field in self.free_cells:
            if ignore and field.value == ignore.value and field.color == ignore.color:
                continue
            field.draw()
        for field in self.fields:
            if ignore and field.value == ignore.value and field.color == ignore.color:
                continue
            field.draw()
        if ignore:
            ignore.draw()
        # if ignore:
        #     for field in self.dom:
        #         if field.value == ignore.value:
        #             field.draw()
        #             return

    def update(self, solution):
        global cards_old, cards_now
        changed = []
        i = 0
        card_id = 0
        self.fields = []
        cards_now = {}
        for column in solution[2]:
            row_i = 0
            x = (config.card_size['width'] // 2 + config.step) + (config.card_size['width'] + config.step) * i + int(config.step * 0.75)
            y = config.step + config.card_size['height'] // 2 + config.card_size['height'] + config.step + config.step * row_i
            for row in reverse(column):
                y = config.step + config.card_size['height'] // 2 + config.card_size['height'] + (config.card_size['height'] // 8) * (row_i + 1)
                card = FieldField(card_id, x, y, self.screen, Card(row))
                cards_now[str(row)] = [x, y]
                if cards_old[str(row)][0] != x or cards_old[str(row)][1] != y:
                    old_card = FieldField(card_id, cards_old[str(row)][0], cards_old[str(row)][1], self.screen, Card(row))
                    changed = [old_card, cards_old[str(row)], cards_now[str(row)]]
                    self.fields.append(old_card)
                else:
                    self.fields.append(card)

                card_id += 1
                row_i += 1
            i += 1
        self.old_fields = solution[2].copy()

        i = 0
        card_id = 0
        self.dom = []
        self.old_dom = solution[0].copy()
        for column in solution[0]:
            row_i = 0

            x = (config.card_size['width'] // 2 + config.step) + (config.card_size['width'] + config.step) * (i)
            for row in reverse(column):
                y = config.step + config.card_size['height'] // 2

                card = FieldField(card_id, x, y, self.screen, Card(row))
                cards_now[str(row)] = [x, y]
                if cards_old[str(row)][0] != x or cards_old[str(row)][1] != y:
                    old_card = FieldField(card_id, cards_old[str(row)][0], cards_old[str(row)][1], self.screen, Card(row))
                    changed = [old_card, cards_old[str(row)], cards_now[str(row)]]
                    self.dom.append(old_card)
                else:
                    self.dom.append(card)
                card_id += 1
                row_i += 1
            i += 1
        # self.old_dom = self.dom.copy()


        i = 0
        card_id = 0
        self.free_cells = []
        # self.data = {}
        # self.old_data = {}
        for_delete = []
        # print(self.old_data)
        for key in self.old_data.keys():
            if key not in [str(x) for x in solution[1]]:
                for_delete.append(key)
        for key in for_delete:
            del self.old_data[str(key)]
        # print(self.old_data)

        for row in solution[1]:
            row_i = 0
            curr_i = i
            if str(row) not in self.old_data.keys():
                curr_i = random.choice([index for index in range(config.dom_len) if index not in list(self.old_data.values())])
                self.old_data[str(row)] = curr_i
            else:
                curr_i = self.old_data[str(row)]
            # if row in self.old_free_cells:
            #     curr_i = self.old_free_cells.index(row)

            x = WIDTH - ((config.card_size['width'] // 2 + config.step) + (config.card_size['width'] + config.step) * (curr_i))
            # for row in reverse(column):
            y = config.step + config.card_size['height'] // 2

            card = FieldField(card_id, x, y, self.screen, Card(row))
            # self.free_cells.append(card)
            cards_now[str(row)] = [x, y]
            if cards_old[str(row)][0] != x or cards_old[str(row)][1] != y:
                old_card = FieldField(card_id, cards_old[str(row)][0], cards_old[str(row)][1], self.screen, Card(row))
                changed = [old_card, cards_old[str(row)], cards_now[str(row)]]
                self.free_cells.append(old_card)
            else:
                self.free_cells.append(card)
            card_id += 1
            row_i += 1
            i += 1
        # self.old_free_cells = self.free_cells.copy()

        cards_old = cards_now.copy()
        self.old_free_cells = solution[1].copy()
        return changed

    def event_type(self, solution):

        for field1, field2 in zip(self.old_dom, solution[0]):
            if field1 == [[]] and field2 != []:
                return 'move_to_dom'

            if len(field2) != 0 and len(field1) == 0:
                return 'move_to_dom'

            if len(field2) == 0 and (len(field1) == 0 or len(field1[0]) == 0):
                continue

            elif (len(field1[0]) > 0 and len(field2[0]) > 0) and field1[0][0] != field2[0][0] and field1[-1][0] != field2[0][0]:
                return 'move_to_dom'
            elif len(field1[0]) == 0 and  len(field2[0]) > 0:
                return 'move_to_dom'


        if len(self.old_free_cells) > len(solution[1]):
            return 'move_from_free_cell'
        elif len(self.old_free_cells) < len(solution[1]):
            return 'move_to_free_cell'
        else:
            return 'fields_swap'

def get_transposed(matrix):
    array = []
    for row in matrix:
        array.append(np.array(row))
    array = np.array(array).transpose()
    for row in array:
        for card in row:
            card_string = str(card)
            print(f"{card_string:>14}", end='')
        print()
    return array

class FieldField:
    def __init__(self, i, x, y, screen, card: Card):
        self.screen = screen
        self.value = card.value
        self.color = card.color
        self.i = i
        self.x = x
        self.y = y
        self.rect = pygame.Rect(x - config.card_size['width'] // 2, y - config.card_size['height'] // 2,  config.card_size['width'], config.card_size['height'])
        self.text_surface_object = pygame.font.SysFont('Comic Sans MS', int(config.card_size['height'] // 3)).render(str(card.value+2), True, COLORS[card.color])
        self.text_surface_object_mini = pygame.font.SysFont('Comic Sans MS', int(config.card_size['height'] // 10)).render(str(card.value+2), True, COLORS[card.color])

    def move(self, x, y):
        self.rect.move_ip(x, y)

    def draw(self):
         pygame.draw.rect(self.screen, WHITE, self.rect, int(config.card_size['width']), 3)
         pygame.draw.rect(self.screen, BLACK, self.rect, 2, 3)
         pygame.draw.rect(self.screen, WHITE, pygame.Rect(self.x - config.card_size['width'] // 2 + 2, self.y - config.card_size['height'] // 2 + 2,  config.card_size['width'] - 4, config.card_size['height'] - 4), 2, 3)
         text_rect = self.text_surface_object.get_rect(center=self.rect.center)
         self.screen.blit(self.text_surface_object, text_rect)
         text_rect_mini = self.text_surface_object.get_rect(x=self.rect.x+2, y= self.rect.y)
         self.screen.blit(self.text_surface_object_mini , text_rect_mini)


class Gui:
    def __init__(self, solution):
        self.solution = solution

        pygame.init()
        pygame.mixer.init()
        pygame.font.init()


        screen = pygame.display.set_mode((WIDTH, HEIGHT))
        screen.fill(GREEN_DARK)

        pygame.display.set_caption("Solitaire")
        clock = pygame.time.Clock()
        all_sprites = pygame.sprite.Group()

        dom = Dom()
        dom_fields = [DomField(i, (config.card_size['width'] // 2 + config.step) + (config.card_size['width'] + config.step) * (i), config.step + config.card_size['height'] // 2, screen) for i in range(config.dom_len)]
        dom.fields = dom_fields
        dom.cords = [field.rect.center for field in dom.fields]

        free = FreeCells(screen)
        free_fields = [FreeCellsField(i, WIDTH - ((config.card_size['width'] // 2 + config.step) + (config.card_size['width'] + config.step) * (i)), config.step + config.card_size['height'] // 2, screen) for i in range(config.dom_len)]
        free.fields = free_fields
        free.cords = [field.rect.center for field in free.fields]


        field = Field(screen)
        i = 0
        card_id = 0
        for column in self.solution[0][2]:
            row_i = 0
            x = (config.card_size['width'] // 2 + config.step) + (config.card_size['width'] + config.step) * i + int(config.step * 0.75)
            y = config.step + config.card_size['height'] // 2 + config.card_size['height'] + config.step + config.step * row_i
            for row in reverse(column):
                y = config.step + config.card_size['height'] // 2 + config.card_size['height'] + (config.card_size['height'] // 8) * (row_i + 1)
                card = FieldField(card_id, x, y, screen, Card(row))
                cards_old[str(row)] = [x, y]
                field.fields.append(card)
                card_id += 1
                row_i += 1
            i += 1
        field.old_fields = field.fields
        field.old_dom = [[[]] for _ in range(config.dom_len)]

        field_empty = Dom()
        i = 0
        for column in self.solution[0][2]:
            x = (config.card_size['width'] // 2 + config.step) + (config.card_size['width'] + config.step) * i + int(config.step * 0.75)
            y = config.step + config.card_size['height'] // 2 + config.card_size['height'] + config.step + config.step
            card = DomField(i, x, y, screen)
            field_empty.fields.append(card)
            i += 1


        # field_empty_fields = [DomField(i, (config.card_size['width'] // 2 + config.step) + (
        #             config.card_size['width'] + config.step) * (i), config.step + config.card_size['height'] // 2,
        #                        screen) for i in range(config.dom_len)]

        # Цикл игры
        screen.fill(GREEN_DARK)
        dom.draw()
        free.draw()
        field_empty.draw()
        field.draw()
        pygame.display.flip()
        running = True
        step = 1
        dstep = STEP_BY
        card_moving = []
        animation = False
        while running:
            # Держим цикл на правильной скорости
            clock.tick(60)
            # Ввод процесса (события)

            if animation and (dstep == 1 or step < dstep):
                # bx = changed[1][0]
                # by = changed[1][1]
                # ax = changed[2][0]
                # ay = changed[2][1]
                # t = 0.5
                # if not changed:
                #     screen.fill(GREEN_DARK)
                #     dom.draw()
                #     field_empty.draw()
                #     free.draw()
                #     field.draw()
                #     changed = field.update(self.solution[step])
                #
                #     StepField(0, WIDTH - 50, HEIGHT - 50, screen, step, len(self.solution) + 1).draw()
                #     pygame.display.flip()
                # import time
                # time.sleep(10)
                if abs(changed[0].rect.centerx - changed[2][0]) > 1:
                    dx = 1
                    if abs(changed[0].rect.centerx - changed[2][0]) > 10:
                        dx = 10
                    if changed[0].rect.centerx > changed[2][0]:
                        changed[0].move(-1 * dx, 0)
                    elif changed[0].rect.centerx < changed[2][0]:
                        changed[0].move(1 * dx, 0)

                if abs(changed[0].rect.centery - changed[2][1]) > 1:
                    dy = 1
                    if abs(changed[0].rect.centery - changed[2][1]) > 10:
                        dy = 10
                    if changed[0].rect.centery > changed[2][1]:
                        changed[0].move(0, -1 * dy)
                    elif changed[0].rect.centery < changed[2][1]:
                        changed[0].move(0, 1 * dy)

                if abs(changed[0].rect.centery - changed[2][1]) <= 1 and abs(changed[0].rect.centerx - changed[2][0]) <= 1:
                    animation = False

                screen.fill(GREEN_DARK)
                dom.draw()
                field_empty.draw()
                free.draw(changed[0])
                field.draw(changed[0])
                StepField(0, WIDTH - 50, HEIGHT - 50, screen, step, len(self.solution)).draw()
                pygame.display.flip()

            else:

                event = pygame.event.wait()
                while event.type != KEYDOWN:
                    event = pygame.event.wait()
                    if event.type == pygame.QUIT:
                        running = False

                if step + dstep >= len(self.solution) or step >= len(self.solution) - dstep:
                    dstep = 1
                if step < dstep:
                    screen.fill(GREEN_DARK)
                    dom.draw()
                    free.draw()
                    field_empty.draw()
                    field.draw()
                    StepField(0, WIDTH - 150, HEIGHT - 50, screen, step, len(self.solution)).draw()
                    if step == len(self.solution):
                        input()
                        break

                    changed = field.update(self.solution[step])
                    step += 1
                    animation = True

                    pygame.display.flip()

                    continue
                for _ in range(dstep):
                    screen.fill(GREEN_DARK)
                    dom.draw()
                    free.draw()
                    field_empty.draw()
                    field.draw()
                    StepField(0, WIDTH - 150, HEIGHT - 50, screen, step, len(self.solution)).draw()
                    if step == len(self.solution):
                        input()
                        break

                    changed = field.update(self.solution[step])
                    step += 1
                    animation = True

                    pygame.display.flip()
                    # import time
                    # time.sleep(10)
        pygame.quit()


class Bridge:
    prolog = Prolog

    def __init__(self):
        self.prolog = Prolog()
        self.prolog.consult("/Users/ivankovalenko/PycharmProjects/solitaire/solve.pl")

    def solve(self, max_value: int, color: int):
        solution = list(self.prolog.query(f"solve({max_value}, {color}, Solution)"))[0]["Solution"]
        str_solution = str(solution)
        ts = TrustedSolutionPrinter(str_solution)
        ts.print()
        return ts.get_raw_solution()


    def solve_mock(self, field, max_value: int, color: int):
        solution = list(self.prolog.query(f"create_solution({field}, {max_value}, {color}, Solution)"))[0]["Solution"]
        str_solution = str(solution)
        ts = TrustedSolutionPrinter(str_solution)
        ts.print()
        return ts.get_raw_solution()



config = SingletonConfig()

# for raw_state in s:
#     raw_dom = raw_state[0]
#     raw_free_cells = raw_state[1]
#     raw_field = raw_state[2]
#
#     # config = SingletonConfig()
#     config.update_columns_in_field(len(raw_field))
#     max_depth = 0
#     for column in raw_field:
#         if len(column) > max_depth:
#             max_depth = len(column)
#     config.update_rows_in_column(max_depth)
#     config.update_free_cells_len(len(raw_dom))
#     config.update_dom_len(len(raw_dom))


bridge = Bridge()

STEP_BY = 10
field =[
	[[2, 0], [11, 0], [11, 1], [2, 2], [4, 2], [3, 3], [10, 0]],
	[[1, 2], [8, 3], [8, 0], [0, 2], [12, 3], [10, 2], [8, 1]],
	[[0, 0], [5, 3], [7, 1], [0, 1], [8, 2], [9, 0], [1, 1]],
	[[0, 3], [2, 3], [6, 0], [9, 2], [5, 1], [6, 1], [12, 2]],
	[[5, 0], [7, 2], [4, 1], [1, 3], [3, 2], [2, 1]],
	[[12, 1], [10, 3], [11, 2], [9, 1], [4, 3], [3, 0]],
	[[6, 3], [6, 2], [9, 3], [1, 0], [11, 3], [3, 1]],
	[[10, 1], [7, 3], [12, 0], [4, 0], [5, 2], [7, 0]]
]

new_field = []
for f in field:
	new_field.append(f[::-1])
print(new_field)

# черви 0
# буби 1
# крести 2
# пики 3
# 0 2
# 1 3
# 2 4
# 3 5
# 4 6
# 5 7
# 6 8
# 7 9
# 8 10
# 9 валет
# 10 дама
# 11 король
# 12 туз

import os
import sys
from time import process_time


def stopwatch(function, params) -> float:
    """
    :param function: function-pointer, that you want to test
    :param params: array of parametres, that your function requires
    :return: float of time, that your function runs
    Process time of your function: sum of the kernel and user-space CPU time.
    Uses process_time library
    """

    class HiddenPrints:
        """
        uses to disable prints, that your function may use
        Uses just to keep terminal clean :)
        """

        def __enter__(self):
            self._original_stdout = sys.stdout
            sys.stdout = open(os.devnull, 'w')

        def __exit__(self, exc_type, exc_val, exc_tb):
            sys.stdout.close()
            sys.stdout = self._original_stdout

    start = process_time()

    with HiddenPrints():
        function(*params)

    end = process_time()

    return end - start

# print(stopwatch(bridge.solve_mock, [field, 13, 4]))
#

field = [
	[[0, 0],[1, 1]],
	[[0, 1], [1, 2]],
	[[1, 0],],
	[[0, 2]],
]
solution = bridge.solve_mock(field, 2,3)
# solution = bridge.solve(4, 2)
gui = Gui(solution)
