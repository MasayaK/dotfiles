namespace <%filename_noext%> {
    using System;
    using System.Drawing;
    using System.Windows.Forms;

    class Program {
        public static void Main() {
            Application.Run( new Form1() );
        }
    }

    class Form1 : Form {
        public Form1() {
          this.Text = "Hello";
        }
    }
}
