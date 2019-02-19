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

        static bool menu = true;

        // User/AI input
        static string moveSquare = "hello";

        // Get input from user
        static int square = 0;

        // Who is the player?
        static char player; // = 'm';

        // Cosmetic
        static bool firstMove = true;

        // Functional Stuff
        static bool firstRun = true;
        static bool exit = false;

        static void Main(string[] args)
        {   
            // Show menu when menu == true
            while (menu == true) {
                Console.Clear();
                Console.Write("\nSelect Player:\nx\no\n");

                if (firstRun == false){
                    Console.Write("\nInvalid input. Try again.\n\n");
                }
                else {
                    Console.Write("\n\n\n");
                }

                string userInput = Console.ReadLine();

                if (userInput == "1" || userInput == "x") {
                    player = Convert.ToChar("x");
                    menu = false;
                }
                else if (userInput == "2" || userInput == "o") {
                    player = Convert.ToChar("o");
                    menu = false;
                }
                else if (userInput == "exit"){
                    menu = false;
                    exit = true;
                    Console.Clear();
                }
                else {
                    Console.Clear();
                }

                if (menu == false && exit == false) {
                    gameon = true;
                    Console.Clear();
                    Console.Write(PrintGrid());
                    Console.Write("Game On!\n\n");
                }

                firstRun = false;
            }


            while (numberMoves <= 9 && gameon == true) {
                
                if (turn == player) {
                    moveSquare = Console.ReadLine();
                }
                else {
                    moveSquare = aiMove();
                }

                // Debugging purposes
                if (moveSquare == "dbgstalemate") {
                    numberMoves = 9;
                }
                else if (moveSquare == "exit") {
                    gameon = false;
                    Console.Clear();
                }
                // Error check if input is square
                else if (!int.TryParse(moveSquare, out square)) {
                    Console.Clear();
                    Console.Write(PrintGrid());
                    Console.WriteLine("Improper input. Try again player " + turn + "\n");
                }
                //Check for valid move
                else if (square >= 1 && square <=9 && grid[square - 1] == '-') {
                    grid[square - 1] = turn;
                    Console.Clear();
                    Console.Write(PrintGrid());

                    // End game if CheckWin() returns true
                    if (CheckWin() == true) {
                        Console.WriteLine(turn + " has won!\n");
                        gameon = false;
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
                    Console.WriteLine("It's a stalemate!\n");
                    // This line below is mainly for the dbstalemate function
                    gameon = false;
                }
            }
        }

        // Set the playing field
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
                }
                else if (numberMoves == 1) {
                    plan = "b";
                    move = 1;
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

        // Check 8 ways of winning
        static bool CheckWin(){
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