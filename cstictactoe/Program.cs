using System;

namespace cstictactoe
{
    class Program
    {
        // Create a grid of squares
        static char[] grid = new char[] {'-','-','-','-','-','-','-','-','-'};
        static char turn = 'x';
        static int numberMoves = 0;
        static bool gameon = true;

        // Check 8 ways of winning

        static bool CheckWin(){

            if(grid[0] == grid[1] && grid[1] == grid[2] && grid[0] != '-'){
                return true;
            }
            else if(grid[3] == grid[4] && grid[4] == grid[5] && grid[3] != '-'){
                return true;
            }
            else if(grid[6] == grid[7] && grid[7] == grid[8] && grid[6] != '-'){
                return true;
            }
            else if(grid[0] == grid[3] && grid[3] == grid[6] && grid[0] != '-'){
                return true;
            }
            else if(grid[1] == grid[4] && grid[4] == grid[7] && grid[1] != '-'){
                return true;
            }
            else if(grid[2] == grid[5] && grid[5] == grid[8] && grid[2] != '-'){
                return true;
            }
            else if(grid[0] == grid[4] && grid[4] == grid[8] && grid[0] != '-'){
                return true;
            }
            else if(grid[2] == grid[4] && grid[4] == grid[6] && grid[2] != '-'){
                return true;
            }
            else{
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

        static void Main(string[] args)
        {
            // Clear terminal content for clean game environment :)
            Console.Clear();
            Console.Write(PrintGrid());

            while(numberMoves < 9 && gameon == true) {
                // Get input from user
                string moveSquare = Console.ReadLine();
                int square = 0;

                // Error check wrong input (not an integer)
                if(!int.TryParse(moveSquare, out square)) {
                    Console.WriteLine("Improper input. Try again player " + turn);
                }

                //Check for valid move
                else if (square >= 1 && square <=9 && grid[square - 1] == '-') {
                    grid[square - 1] = turn;

                    Console.Clear();
                    Console.Write(PrintGrid());

                    if (CheckWin() == true) {
                        Console.WriteLine(turn + " has won!\n\n");
                        gameon = false;
                    }

                    else {
                        if(turn == 'x') {
                            turn = 'o';
                        }

                        else {
                            turn = 'x';
                        }

                        numberMoves++;
                    }
                }

                else {
                    Console.WriteLine("Improper input. Try again player " + turn);
                }
            }
        }
    }
}