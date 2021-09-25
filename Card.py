import pygame

from Constants import *

class Card(pygame.sprite.Sprite):
    value = int
    color = int

    def __init__(self, card_array):
        if len(card_array) != 2:
            assert("Card array lenght is not 2")
        self.value = card_array[0]
        self.color = card_array[1]

        pygame.sprite.Sprite.__init__(self)
        config = SingletonConfig()
        self.image = pygame.Surface((config.card_size['width'], config.card_size['height']))
        self.image.fill(COLORS[self.color])
        self.rect = self.image.get_rect()
        self.rect.center = (WIDTH / 2, HEIGHT / 2)


    def _get_color_reference(self) -> (str, str):
        if self.color == 0:
            return ("R", Fore.RED)
        elif self.color == 1:
            return ("Bl", Fore.BLACK)
        elif self.color == 2:
            return ("B", Fore.BLUE)
        elif self.color == 3:
            return ("Y", Fore.YELLOW)
        elif self.color == 4:
            return ("W", Fore.LIGHTWHITE_EX)

    def __str__(self):
        if self.value < 0 and self.color < 0:
            return FColors.INVISIBLE + ""
        color, termcolor = self._get_color_reference()
        return termcolor + f"{self.value}{color}"