using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace InvadersCS
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();

            label2.Click += label1_Click;
            label3.Click += label1_Click;
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }
    }
}
