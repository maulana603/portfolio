#Created by Maulana Ariefai (maulana.ariefai60@gmail.com)
#self studying how to make a simple game using pygame. You can play in the terminal using play_game() function
#or play in the UI using play_game_with_gui() function

import pygame

class OthelloBoard:
    def __init__(self, board_size):
        self.board = [[0 for _ in range(board_size)] for _ in range(board_size)]
        self.board[3][3] = 1
        self.board[3][4] = -1
        self.board[4][3] = -1
        self.board[4][4] = 1
        
    def display(self):
        for row in self.board:
            print(row)

class OthelloPlayer:
    def __init__(self, name, color):
        self.name = name
        self.color = color

def is_valid_move(board, color, x, y):
    if board[x][y] != 0:
        return False
    for dx, dy in [[-1, 0], [1, 0], [0, -1], [0, 1], [-1, -1], [-1, 1], [1, -1], [1, 1]]:
        if check_direction(board, color, x, y, dx, dy):
            return True
    return False

def check_direction(board, color, x, y, dx, dy):
    x += dx
    y += dy
    if x < 0 or x >= 8 or y < 0 or y >= 8:
        return False
    if board[x][y] == color:
        return True
    if board[x][y] == 0:
        return False
    return check_direction(board, color, x, y, dx, dy)

def apply_move(board, color, x, y):
    board[x][y] = color
    for dx, dy in [[-1, 0], [1, 0], [0, -1], [0, 1], [-1, -1], [-1, 1], [1, -1], [1, 1]]:
        if check_and_flip(board, color, x, y, dx, dy):
            continue
    return board

def check_and_flip(board, color, x, y, dx, dy):
    x += dx
    y += dy
    if x < 0 or x >= 8 or y < 0 or y >= 8 or board[x][y] == 0:
        return False
    if board[x][y] == color:
        return True
    if check_and_flip(board, color, x, y, dx, dy):
        board[x][y] = color
        return True
    return False

# def play_game():
#     board = OthelloBoard()
#     player1 = OthelloPlayer("Player 1", 1)
#     player2 = OthelloPlayer("Player 2", -1)
#     current_player = player1
#     while True:
#         board.display()
#         print(f"{current_player.name}'s turn")
#         x = int(input("Enter x coordinate: "))
#         y = int(input("Enter y coordinate: "))
#         if is_valid_move(board.board, current_player.color, x, y):
#             apply_move(board.board, current_player.color, x, y)
#         else:
#             print("Invalid move!")
#             continue
#         if current_player == player1:
#             current_player = player2
#         else:
#             current_player = player1

def check_win(board, current_color):
    color_count = {-1:0, 1:0}
    for row in board:
        for cell in row:
            if cell != 0:
                color_count[cell] += 1
    if color_count[current_color] == 0 or color_count[-current_color] == 0:
        return True
    return False

def play_game(board_size = 8):
    board = OthelloBoard(board_size)
    player1 = OthelloPlayer("Player 1", 1)
    player2 = OthelloPlayer("Player 2", -1)
    current_player = player1
    max_moves = board_size*board_size
    move_counter = 0
    while True:
        board.display()
        print(f"{current_player.name}'s turn")
        x = int(input("Enter x coordinate: "))
        y = int(input("Enter y coordinate: "))
        if is_valid_move(board.board, current_player.color, x, y):
            move_counter +=1
            apply_move(board.board, current_player.color, x, y)
        else:
            print("Invalid move!")
            continue
        if check_win(board.board, current_player.color):
            print(f'{current_player.name} wins!')
            break
        if move_counter == max_moves:
            print("Game Drawn!")
            break
        if current_player == player1:
            current_player = player2
        else:
            current_player = player1

def play_game_with_gui(board_size = 8):
    pygame.init()
    width = height = 512
    screen = pygame.display.set_mode((width, height))
    font = pygame.font.Font(None, 30)
    board = OthelloBoard(board_size)
    player1 = OthelloPlayer("Player 1", 1)
    player2 = OthelloPlayer("Player 2", -1)
    current_player = player1
    max_moves = board_size*board_size
    move_counter = 0
    while True:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                return

        # render the board
        screen.fill((0,0,0))
        for i in range(board_size):
            for j in range(board_size):
                x = j*(width//board_size)
                y = i*(height//board_size)
                color = (255,255,255) if board.board[i][j] == 1 else (0,0,0) if board.board[i][j] == -1 else (100,100,100)
                pygame.draw.rect(screen, color, (x,y,width//board_size,height//board_size))

        # display current player name
        text = font.render(f"{current_player.name}'s turn", True, (255,255,255))
        screen.blit(text, (10, 10))

        pygame.display.flip()

        x, y = pygame.mouse.get_pos()
        x, y = x//(width//board_size), y//(height//board_size)
        if pygame.mouse.get_pressed()[0]:
            if is_valid_move(board.board, current_player.color, x, y):
                move_counter +=1
                apply_move(board.board, current_player.color, x, y)
            else:
                print("Invalid move!")
                continue
            if check_win(board.board, current_player.color):
                print(f'{current_player.name} wins!')
                pygame.quit()
                return
            if move_counter == max_moves:
                print("Game Drawn!")
                pygame.quit()
                return
            if current_player == player1:
                current_player = player2
            else:
                current_player = player1

play_game_with_gui()
