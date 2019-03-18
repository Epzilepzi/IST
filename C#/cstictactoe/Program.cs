using System;

namespace cstictactoe
{
    class Program
    {
        // Create a grid of squares
        static char[] grid = new char[] {'-','-','-','-','-','-','-','-','-'};

        // Sets 'x' as first turn
        static char turn = 'x';

        // Counts number of moves
        static int numberMoves = 0;

        static bool gameon = false;

        // Select game
        static bool menu = true;
        // Tic Tac Toe Mode Select
        static bool menu1 = false;
        // Tic Tac Toe Player Select
        static bool menu2 = false;

        static bool game = true;

        // User/AI input
        static string moveSquare = "hello";
        static bool bot = false;

        // Get input from user
        static int square = 0;

        // Who is the player?
        static char player; // = 'm';

        // Cosmetic
        static bool firstMove = true;

        // Functional Stuff
        static bool firstRun = true;
        static bool exit = false;

        // Test thing
        static bool test = false;
        static bool hangman = false;

        static void beep() {
            Console.Beep();
            // SystemSounds.Beep.Play();
        }

        static void resetGame() {
            gameon = false;
            menu1 = false;
            menu2 = false;
            bot = false;
            firstMove = true;
            firstRun = true;
            exit = false;
            test = false;
            hangman = false;
            menu = true;
        }

        static void Main(string[] args)
        {   
            while (game == true) {
                while (menu == true) {
                    Console.Clear();
                    Console.Write("Welcome to GameHub!\n\nSelect Game to Play:\n1.) Tic Tac Toe\n2.) Hangman\n");

                    if (firstRun == false && test == false){
                        Console.Write("\nInvalid input. Try again.\n\n");
                    }
                    else if (test == true) {
                        Console.Write("\nComing Soon!\n\n");
                    }
                    else {
                        Console.Write("\n\n\n");
                    }

                    string option = Console.ReadLine().ToLower();
                    firstRun = false;

                    if (option == "1" || option == "t" || option == "tic tac toe" || option == "tictactoe" || option == "tic") {
                        menu = false;
                        menu1 = true;
                        firstRun = true;
                    }
                    else if (option == "2" || option == "h" || option == "hangman" || option == "hang man" || option == "hang") {
                        // menu = false;
                        // hangman = true;
                        firstRun = true;
                        test = true;
                    }
                    else if (option == "beep") {
                        beep();
                        firstRun = true;
                    }
                    else if (option == "exit") {
                        menu = false;
                        test = false;
                        game = false;
                        Console.Clear();
                    }
                    else if (option == "menu" || option == "reset") {
                        resetGame();
                    }
                }

                while (menu1 == true) {
                    Console.Clear();
                    Console.Write("\nWelcome to Tic Tac Toe!\n\n1.) One Player Game\n2.) Two Player Game\n");

                    if (firstRun == false){
                        Console.Write("\nInvalid input. Try again.\n\n");
                    }
                    else {
                        Console.Write("\n\n\n");
                    }

                    string userInput = Console.ReadLine();
                    firstRun = false; 

                    if (userInput == "1") {
                        menu2 = true;
                        menu1 = false;
                        bot = true;
                        firstRun = true; 
                    }
                    else if (userInput == "2") {
                        gameon = true;
                        menu1 = false;
                        bot = false;
                        firstRun = true; 
                        Console.Clear();
                        Console.Write(PrintGrid());
                        Console.Write("Game On!\n\n");
                    }
                    else if (userInput == "exit"){
                        menu1 = false;
                        exit = true;
                        game = false;
                        Console.Clear();
                    }
                    else if (userInput == "menu" || userInput == "reset") {
                        resetGame();
                    }
                    else if (userInput == "beep") {
                        beep();
                    }               
                }

                // Show player select when menu2 == true
                while (menu2 == true) {
                    Console.Clear();
                    Console.Write("\nSelect Player:\n\n1.) x\n2.) o\n");

                    if (firstRun == false){
                        Console.Write("\nInvalid input. Try again.\n\n");
                    }
                    else {
                        Console.Write("\n\n\n");
                    }

                    string userInput = Console.ReadLine();
                    firstRun = false; 

                    if (userInput == "1" || userInput == "x") {
                        player = Convert.ToChar("x");
                        menu2 = false;
                        bot = true;
                    }
                    else if (userInput == "2" || userInput == "o") {
                        player = Convert.ToChar("o");
                        menu2 = false;
                        bot = true;
                    }
                    else if (userInput == "exit"){
                        menu2 = false;
                        exit = true;
                        game = false;
                        Console.Clear();
                    }
                    else if (userInput == "menu" || userInput == "reset") {
                        resetGame();
                    }
                    else if (userInput == "beep") {
                        beep();
                    }             

                    if (menu2 == false && exit == false) {
                        gameon = true;
                        Console.Clear();
                        Console.Write(PrintGrid());
                        Console.Write("Game On!\n\n");
                    }
                }
                
                while (numberMoves <= 9 && gameon == true) {
                
                    if (turn != player && bot == true) {
                        moveSquare = aiMove();
                    }
                    else {
                        moveSquare = Console.ReadLine();
                    }

                    // Debugging purposes
                    if (moveSquare == "dbgstalemate") {
                        numberMoves = 9;
                    }
                    else if (moveSquare == "exit") {
                        gameon = false;
                        game = false;
                        Console.Clear();
                    }
                    else if (moveSquare == "menu" || moveSquare == "reset") {
                        resetGame();
                    }
                    else if (moveSquare == "beep") {
                        beep();
                    }             
                    // Error check if input is square
                    else if (!int.TryParse(moveSquare, out square)) {
                        Console.Clear();
                        Console.Write(PrintGrid());
                        Console.WriteLine("Improper input. Try again player " + turn + "\n");
                    }
                    //Check for valid move
                    else if (square >= 1 && square <= 9 && grid[square - 1] == '-') {
                        grid[square - 1] = turn;
                        Console.Clear();
                        Console.Write(PrintGrid());

                        // End game if CheckWin() returns true
                        if (CheckWin() == true) {
                            gameon = false;
                            Console.WriteLine(turn + " has won! Type \"reset\" to play again.\n");
                        }
                        // Turn Switching
                        else {
                            if (firstMove == true) {
                                firstMove = false;
                                Console.WriteLine("Game On!\n");
                            }
                            else {
                                Console.WriteLine("\n");
                            }

                            if(turn == 'x') {
                                turn = 'o';
                                
                            }
                            else {
                                turn = 'x';
                            }

                            numberMoves++;
                        }
                    }
                    // Throws error if someone is dumb
                    else {
                        Console.Clear();
                        Console.Write(PrintGrid());
                        Console.WriteLine("Improper input. Try again player " + turn + "\n");
                    }

                    if (numberMoves == 9) {
                        Console.Clear();
                        Console.Write(PrintGrid());
                        Console.WriteLine("It's a stalemate! Type \"reset\" to play again.\n");
                        // This line below is mainly for the dbstalemate function
                        gameon = false;
                    }
                }

                while (gameon == false && game == true && menu == false && menu1 == false && menu2 == false) {
                    string input = Console.ReadLine();
                    if (input == "menu" || input == "reset") {
                        resetGame();
                    }
                    else if (input == "beep") {
                        beep();
                    }  
                    else if (input == "exit") {
                        exit = true;
                        game = false;
                        Console.Clear();
                    }     
                }
            }
        }

        // Set the playing field for Tic Tac Toe
        static string PrintGrid() {
            string output = "\n\n[" +
                grid[0] + "][" +
                grid[1] + "][" +
                grid[2] + "]\n[" +
                grid[3] + "][" +
                grid[4] + "][" +
                grid[5] + "]\n[" +
                grid[6] + "][" +
                grid[7] + "][" +
                grid[8] + "]" +
                "\n\n";
            return output;
        }

        // Normie random algorithm
        static int randomMove() {
            Random rnd = new Random();
            int rand = rnd.Next(1, 10);
            return rand;
        }

        static string plan = "a";

        static int firstPlay;
        // Chad unbeatable algorithm
        static string aiMove() {
            Random rnd = new Random();
            // Strategy when player goes first
            int move = 5;
            int choice = rnd.Next(1, 2);

            if (player == 'x') {
                if (square != 5 && numberMoves == 1) {
                    plan = "a";
                    move = 5;
                    firstPlay = square;
                }
                else if (numberMoves == 1) {
                    plan = "b";
                    move = 1;
                }
                else if (numberMoves == 3) {
                    switch (plan) {
                        case "a":
                                switch (firstPlay) {
                                    // First section is for if player's first move was a corner
                                    case 1:
                                        switch (square) {
                                            case 2:
                                                move = 3;
                                                break;
                                            case 3:
                                                move = 2;
                                                break;
                                            case 4:
                                                move = 7;
                                                break;
                                            case 6:
                                                move = 3;
                                                break;
                                            case 7:
                                                move = 4;
                                                break;
                                            case 8:
                                                move = 7;
                                                break;
                                            case 9:
                                                move = 3;
                                                break;
                                        }
                                        break;
                                    case 3:
                                        switch (square) {
                                            case 1:
                                                move = 2;
                                                break;
                                            case 2:
                                                move = 1;
                                                break;
                                            case 4:
                                                move = 1;
                                                break;
                                            case 6:
                                                move = 9;
                                                break;
                                            case 7:
                                                move = 9;
                                                break;
                                            case 8:
                                                move = 9;
                                                break;
                                            case 9:
                                                move = 6;
                                                break;
                                        }
                                        break;
                                    case 7:
                                        switch (square) {
                                            case 1:
                                                move = 2;
                                                break;
                                            case 2:
                                                move = 1;
                                                break;
                                            case 3:
                                                move = 1;
                                                break;
                                            case 4:
                                                move = 1;
                                                break;
                                            case 6:
                                                move = 9;
                                                break;
                                            case 8:
                                                move = 9;
                                                break;
                                            case 9:
                                                move = 8;
                                                break;
                                        }
                                        break;
                                    case 9:
                                        switch (square) {
                                            case 1:
                                                move = 7;
                                                break;
                                            case 2:
                                                move = 3;
                                                break;
                                            case 3:
                                                move = 6;
                                                break;
                                            case 4:
                                                move = 7;
                                                break;
                                            case 6:
                                                move = 3;
                                                break;
                                            case 7:
                                                move = 8;
                                                break;
                                            case 8:
                                                move = 7;
                                                break;
                                        }
                                        break;
                                    // Second section is if player's first move was on the side
                                    case 2:
                                        switch (square) {
                                            case 1:
                                                move = 3;
                                                break;
                                            case 3:
                                                move = 1;
                                                break;
                                            case 4:
                                                move = 3;
                                                break;
                                            case 6:
                                                move = 1;
                                                break;
                                            case 7:
                                                move = 1;
                                                break;
                                            case 8:
                                                move = 6;
                                                break;
                                            case 9:
                                                move = 3;
                                                break;
                                        }
                                        break;
                                    case 4:
                                        switch (square) {
                                            case 1:
                                                move = 7;
                                                break;
                                            case 2:
                                                move = 1;
                                                break;
                                            case 3:
                                                move = 1;
                                                break;
                                            case 6:
                                                move = 7;
                                                break;
                                            case 7:
                                                move = 1;
                                                break;
                                            case 8:
                                                move = 7;
                                                break;
                                            case 9:
                                                move = 7;
                                                break;
                                        }
                                        break;
                                    case 6:
                                        switch (square) {
                                            case 1:
                                                move = 3;
                                                break;
                                            case 2:
                                                move = 3;
                                                break;
                                            case 3:
                                                move = 9;
                                                break;
                                            case 4:
                                                move = 1;
                                                break;
                                            case 7:
                                                move = 9;
                                                break;
                                            case 8:
                                                move = 9;
                                                break;
                                            case 9:
                                                move = 3;
                                                break;
                                        }
                                        break;
                                    case 8:
                                        switch (square) {
                                            case 1:
                                                move = 7;
                                                break;
                                            case 2:
                                                move = 3;
                                                break;
                                            case 3:
                                                move = 9;
                                                break;
                                            case 4:
                                                move = 7;
                                                break;
                                            case 6:
                                                move = 9;
                                                break;
                                            case 7:
                                                move = 9;
                                                break;
                                            case 9:
                                                move = 7;
                                                break;
                                        }
                                        break;
                                    default:
                                        move = randomMove();
                                        break;
                                }
                            break;
                        case "b":
                            switch (square) {
                                case 2:
                                    move = 8;
                                    break;
                                case 3:
                                    move = 7;
                                    break;
                                case 4:
                                    move = 6;
                                    break;
                                case 6:
                                    move = 4;
                                    break;
                                case 7:
                                    move = 3;
                                    break;
                                case 8:
                                    move = 2;
                                    break;
                                case 9:
                                    move = 3;
                                    break;
                                default:
                                    move = randomMove(); // For testing only
                                    break;
                            }
                            break;
                    }
                }
                // Left for now, used for debugging
                else {
                    move = randomMove();
                }
            }
            // Strategy when CPU goes first
            else if (player == 'o') {
                if (numberMoves < 1) {
                    plan = "a";
                    move = 5;
                }
                else if (numberMoves == 2) {
                    switch (square) {
                        case 1:
                            plan = "a";
                            switch (choice) {
                                case 1:
                                    move = 4;
                                    break;
                                case 2:
                                    move = 2;
                                    break;
                                default:
                                    move = 2;
                                    break;
                            }
                            break;
                        case 3:
                            plan = "a";
                            switch (choice) {
                                case 1:
                                    move = 2;
                                    break;
                                case 2:
                                    move = 6;
                                    break;
                                default:
                                    move = 6;
                                    break;
                            }
                            break;
                        case 7:
                            plan = "a";
                            switch (choice) {
                                case 1:
                                    move = 8;
                                    break;
                                case 2:
                                    move = 4;
                                    break;
                                default:
                                    move = 4;
                                    break;
                            }
                            break;
                        case 9:
                            plan = "a";
                            switch (choice) {
                                case 1:
                                    move = 8;
                                    break;
                                case 2:
                                    move = 6;
                                    break;
                                default:
                                    move = 8;
                                    break;
                            }
                            break;
                        case 2:
                            switch (choice) {
                                case 1:
                                    move = 3;
                                    break;
                                case 2:
                                    move = 1;
                                    break;
                            }
                            plan = "b";
                            break;
                        case 4:
                            switch (choice) {
                                case 1:
                                    move = 1;
                                    break;
                                case 2:
                                    move = 7;
                                    break;
                            }
                            plan = "b";
                            break;
                        case 6:
                            switch (choice) {
                                case 1:
                                    move = 3;
                                    break;
                                case 2:
                                    move = 9;
                                    break;
                            }
                            plan = "b";
                            break;
                        case 8:
                            switch (choice) {
                                case 1:
                                    move = 6;
                                    break;
                                case 2:
                                    move = 9;
                                    break;
                            }
                            plan = "b";
                            break;
                        default:
                            move = 1;
                            plan = "b";
                            break;
                    }
                }
                // Left for now, used for debugging
                else {
                    move = randomMove();
                }
            }

            return move.ToString();
        }

        // Letter count for word
        static int letterCount = 0;

        // Retrieve a word for hangman from list (?)
        static string getWord(string cat) {
            Random r = new Random();
            int rand = r.Next(1, 4);
            string word = "a word";
            switch (cat) {
                // Category 1 - African Animals
                case "1":
                    switch (rand) {
                        case 1:
                            word = "elephant";
                            letterCount = 8;
                            break;
                        case 2:
                            word = "hippopotamus";
                            letterCount = 12;
                            break;
                    }
                    break;
                // Invalid Category
                default:
                    word = "!";
                    break;
            }
            return word;
        }

        // Check 8 ways of winning
        static bool CheckWin() {
            if (grid[0] == grid[1] && grid[1] == grid[2] && grid[0] != '-') {
                return true;
            }
            else if (grid[3] == grid[4] && grid[4] == grid[5] && grid[3] != '-') {
                return true;
            }
            else if (grid[6] == grid[7] && grid[7] == grid[8] && grid[6] != '-') {
                return true;
            }
            else if (grid[0] == grid[3] && grid[3] == grid[6] && grid[0] != '-') {
                return true;
            }
            else if (grid[1] == grid[4] && grid[4] == grid[7] && grid[1] != '-') {
                return true;
            }
            else if (grid[2] == grid[5] && grid[5] == grid[8] && grid[2] != '-') {
                return true;
            }
            else if (grid[0] == grid[4] && grid[4] == grid[8] && grid[0] != '-') {
                return true;
            }
            else if (grid[2] == grid[4] && grid[4] == grid[6] && grid[2] != '-') {
                return true;
            }
            else {
                return false;
            }
        }
    }
}