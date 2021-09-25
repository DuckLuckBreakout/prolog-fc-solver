from colorama import Fore

class State_commands:
    def __init__(self):
        self.dom_array = "Array"
        self.free_cells_array = "Array"
        self.cards_pool_array = "Array"
        self.get_dom_command = f"ste_machine_get_dom({self.dom_array})"
        self.get_free_cells_array = f"ste_machine_get_free_cells({self.free_cells_array})"
        self.get_cards_poll_array = f"ste_machine_get_card_poll({self.cards_pool_array})"

    def get_generate_cards_pool_command(self, max_value: int, number_of_colors: int) -> str:
        return f"generate_field({max_value}, {number_of_colors}, {self.cards_pool_array})"

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'
    TEXTCOLOR = '\033[1m'

class FColors:
    BLUE = Fore.BLUE
    RED = Fore.BLUE
    GREEN = Fore.BLUE
    BLACK = Fore.BLUE
    # change for theme
    TEXT = Fore.BLUE
    INVISIBLE = Fore.WHITE


# Задаем цвета
WHITE = (255, 255, 255)
YELLOW = (189,183,107)
BLACK = (0, 0, 0)
RED = (255, 0, 0)
GREEN_DARK = (14, 64, 14)
GREEN = (70, 112, 38)
BLUE = (0, 0, 255)
PINK = (255, 0, 255)
PINK_DARK = (147,112,219)

WIDTH = 1280
HEIGHT = 720
FPS = 60

COLORS = [RED, BLACK, BLUE, YELLOW, PINK, PINK_DARK]

class SingletonMeta(type):
    """
    The Singleton class can be implemented in different ways in Python. Some
    possible methods include: base class, decorator, metaclass. We will use the
    metaclass because it is best suited for this purpose.
    """

    _instances = {}

    def __call__(cls, *args, **kwargs):
        """
        Possible changes to the value of the `__init__` argument do not affect
        the returned instance.
        """
        if cls not in cls._instances:
            instance = super().__call__(*args, **kwargs)
            cls._instances[cls] = instance
        return cls._instances[cls]


class SingletonConfig(metaclass=SingletonMeta):
    columns_in_field = 0
    dom_len = 0
    free_cells_len = 0
    card_size = {
        'width': 0,
        'height': 0,
        'k': 88.9 / 63.5
    }
    step = 0

    def update_columns_in_field(self, num):
        self.columns_in_field = num
        self.card_size['width'] = int(WIDTH * 0.9) // self.columns_in_field
        self.card_size['height'] = self.card_size['width'] * self.card_size['k']
        self.step = (WIDTH - int( WIDTH * 0.9)) // (self.columns_in_field + 1)
        self.step = (WIDTH - int( WIDTH * 0.9) - self.step) // (self.columns_in_field + 1)
        print(self.card_size)

    def update_dom_len(self, num):
        self.dom_len = num

    def update_free_cells_len(self, num):
        self.free_cells_len = num

    def update_rows_in_column(self, num):
        height_need_for_column = self.card_size['height'] + (self.card_size['height'] // 8) * num
        k = 0.9
        while height_need_for_column + self.card_size['height'] + 4 * self.step > HEIGHT:
            k -= 0.05
            self.card_size['width'] = int(WIDTH * k) // self.columns_in_field
            self.card_size['height'] = self.card_size['width'] * self.card_size['k']
            self.step = (WIDTH - int(WIDTH * k)) // (self.columns_in_field + 1)
            self.step = (WIDTH - int(WIDTH * k) - self.step) // (self.columns_in_field + 1)
            height_need_for_column = self.card_size['height'] + (self.card_size['height'] // 8) * num
        if k < 0:
            self.card_size['width'] = int(WIDTH * 0.9) // 6
            self.card_size['height'] = self.card_size['width'] * self.card_size['k']
            self.step = (WIDTH - int(WIDTH * 0.9)) // (6 + 1)
            self.step = (WIDTH - int(WIDTH * 0.9) - self.step) // (6 + 1)