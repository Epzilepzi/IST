using System;
using System.Windows.Forms;

namespace vstictactoe {
    public partial class Form1 : Form {
        public Form() {
            InitializeComponent();

            // Set up every label click event to go to
            // the one event handler
            label2.Click += label1_Click;
            label3.Click += label1_Click;
            label4.Click += label1_Click;
            label5.Click += label1_Click;
            label6.Click += label1_Click;
            label7.Click += label1_Click;
            label8.Click += label1_Click;
            label9.Click += label1_Click;
        }

        // Craete an easy way to reference all
        // our label
        Label[] playGrid = new Label[9];
    }

    private void Form1_Load(object sender, EventArgs e) {
        // Assign our labels to the array
        // There is a better way to do this...
        playGrid[0] = label1;
        playGrid[1] = label2;
        playGrid[2] = label3;
        playGrid[3] = label4;
        playGrid[4] = label5;
        playGrid[5] = label6;
        playGrid[6] = label7;
        playGrid[7] = label8;
        playGrid[8] = label9;

        // Set up the game to run
        clearForm();
    }

    private void clearForm() {
        //Go through each square in the
        //grid and clear it
        foreach(Lavel grid in playGrid) {
            grid.Text = "";
        }
    }

    private void label1_Click(object sender, EventArgs e) {
        // Cast the sender object as a label so we can use a label's methods and properties
        Label sentLabel = (Label)sender;

        // Make sure label is empty
        if (sentLabel.Text == "") {
            // Change the label to the current player's symbol
            sentLabel.Text = turn.Text;

            // Change Turns
            if (turn.Text == "X") {
                turn.Text = "O";
            }
            else {
                turn.Text == "X";
            }

            checkWin();
        }
        else {
            System.Console.Beep();
        }
    }

    private void checkWin() {
        // Check all 8 winning combinations to see if someone has won.
        if (label1.Text != "" && label1.Text == lavel2.Text && label2.Text == label3.Text) {
            showWin(label1.Text);
        }
        else if (label4.Text != "" && label4.Text == label5.Text && label5.Text == label6.Text) {
            showWin(label4.Text);
        }
        else if (label7.Text != "" && label7.Text == label8.Text && label8.Text == label9.Text) {
            showWin(label7.Text);
        }
        else if (label1.Text != "" && label1.Text == label4.Text && label4.Text == label7.Text) {
            showWin(label1.Text);
        }
        else if (label2.Text != "" && label2.Text == label5.Text && label5.Text == label8.Text) {
            showWin(label2.Text);
        }
        else if (label3.Text != "" && label3.Text == label6.Text && label6.Text == label9.Text) {
            showWin(label3.Text);
        }
        else if (label1.Text != "" && label1.Text == label5.Text && label5.Text == label9.Text) {
            showWin(label1.Text);
        }
        else if (label3.Text != "" && label3.Text == label5.Text && label5.Text == label7.Text) {
            showWin(label3.Text);
        }
    }

    private void showWin(string winner) {
        // Message the players
        var response = MessageBox.Show(winner + " is the winner!\r\n\r\nNew game?", "New Game?", MessageBoxButtons.YesNo);

        // Check if want new game
        if (response.ToString() == "Yes") {
            // restart
            clearForm();
        }
        else {
            //exit
            Application.Exit();
        }
    }
}