using System;

namespace cstictactoe
{
    class Program
    {
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
                    Console.WriteLine("Thank you for playing Tic Tac Toe!\n");
                    gameon = false;
                }
                // Error check wrong input (not an integer)
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
        // Random algorithm to determine placement
        // This is mainly just for testing to see if turn taking works.
        static string aiMove() {
            // Normie random algorithm
                Random rnd = new Random();
                int rand = rnd.Next(1, 9);
                return rand.ToString();

            /* Chad unbeatable algorithm
                if (rand != null) {
                    return rand.ToString();
                }
                else if (rand == null){
                    return "1";
                }
            */
        }
    }
}