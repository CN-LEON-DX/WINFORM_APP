using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

namespace TH3
{
    public partial class Form1 : Form
    {
        // Nếu tất cả các combo box checkID và các textView như day, month, year là false
        // và listView trống thì không cho click button Chọn ngươcự lại cho bấm sau đó lấy tất cả các thông tin của các phần trên đưa vào richtextbox
        bool checkId = false, checkName = false, checkDay = false, checkYear = false, checkListView = false;
        string connectionString = ConfigurationManager.ConnectionStrings["ConnectionStringTH3"].ConnectionString;

        public Form1()
        {
            InitializeComponent();
        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void groupBox1_Enter(object sender, EventArgs e)
        {

        }

        private void textBox2_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void listView1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void find_infor_pation(object sender, CancelEventArgs e)
        {
            // khi validating dữ liệu nhập vào thì đồng thời check trong cớ sở dũ liệu bảng
            // tbl Bệnh nhân xem có mã bệnh nhân đó hay chưa nếu có thì hiện ra thông tin  ngày tháng năm sinh ở các box
            // nếu không thì không hiện gì thêm giữ nguyên mã đó 
            /*CREATE DATABASE TH4;
                            GO USE TH4;
                            GO

                            CREATE TABLE tblBenhNhan(
                                                MaBN VARCHAR(20),
					                TenBN NVARCHAR(20) 
					                CONSTRAINT pk_tblBenhNhan PRIMARY KEY(MaBN)
				                )
				                GO
                CREATE TABLE tblHopDong(
                                    Ngay DATETIME,
                                    MaBN VARCHAR(20),
					                DichVu NVARCHAR(50),
					                CONSTRAINT fk_tblHopDong_tblBenhNhan FOREIGN KEY(MaBN) REFERENCES tblBenhNhan(MaBN),
					
				                )
				                GO
                CREATE TABLE tblDichVu(
                                    IDDV VARCHAR(20),
					                TenDV NVARCHAR(50),
				                CONSTRAINT pk_tblDichVu PRIMARY KEY(IDDV)
					
				                )
				                GO
                INSERT INTO tblDichVu(IDDV, TenDV)
                VALUES
                ('DV001', N'Xăm lông mày'),
                ('DV002', N'Cắt môi trái tim'),
                ('DV003', N'Triệt lông'),
                ('DV004', N'Nâng mũi'),
                ('DV005', N'Dịch vụ 5'),
                ('DV006', N'Dịch vụ 6'),
                ('DV007', N'Dịch vụ 7'),
                ('DV008', N'Dịch vụ 8'),
                ('DV009', N'Dịch vụ 9'),
                ('DV010', N'Dịch vụ 10');

                            INSERT INTO tblBenhNhan(MaBN, TenBN)
                VALUES
                ('BN001', N'Nguyễn Văn An'),
                ('BN002', N'Nguyễn Thị Bình'),
                ('BN003', N'Trần Văn Chính'),
                ('BN004', N'Lê Thị Doan'),
                ('BN005', N'Hoàng Văn Em');

                            INSERT INTO tblHopDong(Ngay, MaBN, DichVu)
                VALUES
                ('2024-03-18', 'BN001', N'Dịch vụ 1'),
                ('2024-03-19', 'BN002', N'Dịch vụ 2'),
                ('2024-03-20', 'BN003', N'Dịch vụ 3'),
                ('2024-03-21', 'BN004', N'Dịch vụ 4'),
                ('2024-03-22', 'BN005', N'Dịch vụ 5');
                */
            string maBN = comboBox_id.Text;
            if (maBN != "")
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string query = "SELECT TenBN FROM tblBenhNhan WHERE MaBN = @MaBN";
                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@MaBN", maBN);
                        string tenBN = command.ExecuteScalar()?.ToString();
                        if (tenBN != null)
                        {
                            textBox_name.Text = tenBN;

                            // Lấy thông tin ngày tháng năm THỰC HIỆN KHÁM BỆNH BÊN BẢNG tblHopDong của bệnh nhân và hiển thị vào các ô textbox tương ứng
                            query = "SELECT NgaySinh FROM tblBenhNhan WHERE MaBN = @MaBN";
                            using (SqlCommand birthdayCommand = new SqlCommand(query, connection))
                            {
                                birthdayCommand.Parameters.AddWithValue("@MaBN", maBN);
                                object ngaySinh = birthdayCommand.ExecuteScalar();
                                if (ngaySinh != DBNull.Value)
                                {
                                    DateTime birthday = Convert.ToDateTime(ngaySinh);
                                    textBox_day.Text = birthday.Day.ToString();
                                    textBox_month.Text = birthday.Month.ToString();
                                    textBox_year.Text = birthday.Year.ToString();
                                }
                            }

                            // Lấy danh sách dịch vụ của bệnh nhân từ bảng tblHopDong và hiển thị trong ListView
                            listView_service.Items.Clear();
                            query = "SELECT DichVu FROM tblHopDong WHERE MaBN = @MaBN";
                            using (SqlCommand serviceCommand = new SqlCommand(query, connection))
                            {
                                serviceCommand.Parameters.AddWithValue("@MaBN", maBN);
                                using (SqlDataReader reader = serviceCommand.ExecuteReader())
                                {
                                    while (reader.Read())
                                    {
                                        ListViewItem item = new ListViewItem(reader["DichVu"].ToString());
                                        listView_service.Items.Add(item);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            // Khi loadform thì 
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                /*// Lấy danh sách mã bệnh nhân
                string query = "SELECT MaBN FROM tblBenhNhan";
                using (SqlCommand command = new SqlCommand(query, connection))
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        comboBox_id.Items.Add(reader["MaBN"].ToString());
                    }
                }*/

                // Lấy danh sách dịch vụ
                string query = "SELECT TenDV FROM tblDichVu";
                using (SqlCommand command = new SqlCommand(query, connection))
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        comboBox_service.Items.Add(reader["TenDV"].ToString());
                    }
                }
                comboBox_service.SelectedIndex = 0;
            }
        }

        private void comboBox_service_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void comboBox_id_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void validating_find_infor_pation(object sender, CancelEventArgs e)
        {
            string maBN = comboBox_id.Text;
            if (maBN != "")
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string query = "SELECT TenBN FROM tblBenhNhan WHERE MaBN = @MaBN";
                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@MaBN", maBN);
                        string tenBN = command.ExecuteScalar()?.ToString();
                        if (tenBN != null)
                        {
                            textBox_name.Text = tenBN;

                            // Lấy thông tin ngày thực hiện khám bệnh từ bảng tblHopDong và hiển thị trong các TextBox riêng biệt
                            query = "SELECT Ngay FROM tblHopDong WHERE MaBN = @MaBN";
                            using (SqlCommand dateCommand = new SqlCommand(query, connection))
                            {
                                dateCommand.Parameters.AddWithValue("@MaBN", maBN);
                                using (SqlDataReader reader = dateCommand.ExecuteReader())
                                {
                                    if (reader.Read())
                                    {
                                        DateTime ngay = Convert.ToDateTime(reader["Ngay"]);
                                        textBox_day.Text = ngay.Day.ToString();
                                        textBox_month.Text = ngay.Month.ToString();
                                        textBox_year.Text = ngay.Year.ToString();
                                    }
                                }
                            }

                            // Lấy danh sách dịch vụ của bệnh nhân từ bảng tblHopDong và hiển thị trong ListView
                            listView_service.Items.Clear();
                            query = "SELECT DichVu FROM tblHopDong WHERE MaBN = @MaBN";
                            using (SqlCommand serviceCommand = new SqlCommand(query, connection))
                            {
                                serviceCommand.Parameters.AddWithValue("@MaBN", maBN);
                                using (SqlDataReader reader = serviceCommand.ExecuteReader())
                                {
                                    while (reader.Read())
                                    {
                                        ListViewItem item = new ListViewItem(reader["DichVu"].ToString());
                                        listView_service.Items.Add(item);
                                    }
                                }
                            }
                        }
                    }
                }
            }
            checkId = !string.IsNullOrEmpty(comboBox_id.Text);
            checkAddButtonState();
        }



       

        private void Form1_TextChanged(object sender, EventArgs e)
        {
            
          
        }
        private void add_service_to_list(object sender, EventArgs e)
        {
            if (comboBox_service.SelectedItem != null)
            {
                string selectedService = comboBox_service.SelectedItem.ToString();
                ListViewItem item = new ListViewItem(selectedService);
                listView_service.Items.Add(item);
            }
        }

        private void comboBox_id_TextChanged(object sender, EventArgs e)
        {
            // Xác nhận rằng đã nhập mã bệnh nhân
            checkId = !string.IsNullOrEmpty(comboBox_id.Text);
            checkAddButtonState();
        }
        private void checkAddButtonState()
        {
            // Kiểm tra xem nút thêm thông tin bệnh nhân có thể được kích hoạt hay không
            checkListView = listView_service.Items.Count > 0;
            checkName = !string.IsNullOrEmpty(textBox_name.Text);
            checkDay = !string.IsNullOrEmpty(textBox_day.Text);
            checkYear = !string.IsNullOrEmpty(textBox_year.Text);
            button_add_infor_patient.Enabled = checkId && checkName && checkDay && checkYear && checkListView;
        }

        private void textBox_name_TextChanged(object sender, EventArgs e)
        {
            checkName = !string.IsNullOrEmpty(textBox_name.Text);
            checkAddButtonState();
        }

        /*private void click_save_change(object sender, EventArgs e)
        {
            // Hiện thị ra thông báo rằng bạn có xác nhận là thêm và sửa thông tin nhưu trên không
            // cập nhật danh sách các bản ghi của hai bảng tblBenhNhan và tblHopDong 
        }*/
        private void click_save_change(object sender, EventArgs e)
        {
            DialogResult result = MessageBox.Show("Bạn có chắc chắn muốn thêm và sửa thông tin trên không?", "Xác nhận", MessageBoxButtons.YesNo, MessageBoxIcon.Question);

            if (result == DialogResult.Yes)
            {
                string maBN = comboBox_id.Text;
                string tenBN = textBox_name.Text;
                int day = Convert.ToInt32(textBox_day.Text);
                int month = Convert.ToInt32(textBox_month.Text);
                int year = Convert.ToInt32(textBox_year.Text);

                bool benhNhanDaTonTai = KiemTraTonTaiBenhNhan(maBN);

                if (!benhNhanDaTonTai)
                {
                    ThemBenhNhan(maBN, tenBN);
                }

                List<string> dichVuList = LayDanhSachDichVuTuListView(listView_service);
                CapNhatThongTinBenhNhan(maBN, tenBN);

                ThemHoacCapNhatHopDong(maBN, day, month, year, dichVuList);

                XoaThongTinHienTai();

                MessageBox.Show("Thông tin đã được cập nhật thành công!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
            else
            {
            }
        }
        private void XoaThongTinHienTai()
        {
            // Xóa thông tin trong các TextBox của GroupBox
            comboBox_id.Text= "";
            textBox_name.Clear();
            textBox_day.Clear();
            textBox_month.Clear();
            textBox_year.Clear();

            // Xóa thông tin trong ListView
            listView_service.Items.Clear();
        }

        private List<string> LayDanhSachDichVuTuListView(System.Windows.Forms.ListView listView)
        {
            List<string> dichVuList = new List<string>();
            foreach (ListViewItem item in listView.Items)
            {
                dichVuList.Add(item.Text);
            }
            return dichVuList;
        }

        private bool KiemTraTonTaiBenhNhan(string maBN)
        {
            string query = "SELECT COUNT(*) FROM tblBenhNhan WHERE MaBN = @MaBN";
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@MaBN", maBN);
                    int count = (int)command.ExecuteScalar();
                    return count > 0;
                }
            }
        }

        private void ThemBenhNhan(string maBN, string tenBN)
        {
            string insertBenhNhanQuery = "INSERT INTO tblBenhNhan (MaBN, TenBN) VALUES (@MaBN, @TenBN)";
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                using (SqlCommand command = new SqlCommand(insertBenhNhanQuery, connection))
                {
                    command.Parameters.AddWithValue("@MaBN", maBN);
                    command.Parameters.AddWithValue("@TenBN", tenBN);
                    command.ExecuteNonQuery();
                }
            }
        }

        private void CapNhatThongTinBenhNhan(string maBN, string tenBN)
        {
            string updateBenhNhanQuery = "UPDATE tblBenhNhan SET TenBN = @TenBN WHERE MaBN = @MaBN";
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                using (SqlCommand command = new SqlCommand(updateBenhNhanQuery, connection))
                {
                    command.Parameters.AddWithValue("@TenBN", tenBN);
                    command.Parameters.AddWithValue("@MaBN", maBN);
                    command.ExecuteNonQuery();
                }
            }
        }

        private void ThemHoacCapNhatHopDong(string maBN, int day, int month, int year, List<string> dichVuList)
        {
            // Xây dựng truy vấn MERGE để thêm hoặc cập nhật thông tin hợp đồng
            string insertOrUpdateHopDongQuery = "MERGE INTO tblHopDong AS Target " +
                                                 "USING (VALUES (@MaBN, @Ngay, @DichVu)) AS Source(MaBN, Ngay, DichVu) " +
                                                 "ON Target.MaBN = Source.MaBN AND Target.Ngay = Source.Ngay AND Target.DichVu = Source.DichVu " +
                                                 "WHEN MATCHED THEN " +
                                                 "    UPDATE SET Target.Ngay = Source.Ngay " +
                                                 "WHEN NOT MATCHED THEN " +
                                                 "    INSERT (MaBN, Ngay, DichVu) VALUES (Source.MaBN, Source.Ngay, Source.DichVu);";

            // Kết nối đến cơ sở dữ liệu và thực thi truy vấn MERGE
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                foreach (string dichVu in dichVuList)
                {
                    using (SqlCommand command = new SqlCommand(insertOrUpdateHopDongQuery, connection))
                    {
                        DateTime dateTime = new DateTime(year, month, day);
                        command.Parameters.AddWithValue("@MaBN", maBN);
                        command.Parameters.AddWithValue("@Ngay", dateTime);
                        command.Parameters.AddWithValue("@DichVu", dichVu);
                        command.ExecuteNonQuery();
                    }
                }
            }
        }


        private void CLICK_EXIT(object sender, EventArgs e)
        {
            DialogResult result = MessageBox.Show("Bạn muốn thoát ?", "Xác nhận", MessageBoxButtons.YesNo, MessageBoxIcon.Question);

            if (result == DialogResult.Yes)
            {
                this.Close();
            }
        }

        private void textBox_day_TextChanged(object sender, EventArgs e)
        {
            checkDay = !string.IsNullOrEmpty(textBox_day.Text);
            checkAddButtonState();
        }

        private void textBox_year_TextChanged(object sender, EventArgs e)
        {
            checkYear = !string.IsNullOrEmpty(textBox_year.Text);
            checkAddButtonState();
        }

        private void listView_service_SelectedIndexChanged(object sender, EventArgs e)
        {
            checkListView = listView_service.Items.Count > 0;
            checkAddButtonState();
        }
        private void click_add_infor_pattion(object sender, EventArgs e)
        {
            // Kiểm tra nếu tất cả các điều kiện đã được thỏa mãn thì thêm thông tin vào RichTextBox
            if (checkId && checkName && checkDay && checkYear && checkListView)
            {
                StringBuilder info = new StringBuilder();
                info.AppendLine("Mã bệnh nhân: " + comboBox_id.Text);
                info.AppendLine("Tên bệnh nhân: " + textBox_name.Text);
                info.AppendLine("Ngày sinh: " + textBox_day.Text + "/" + textBox_month.Text + "/" + textBox_year.Text);
                info.AppendLine("Dịch vụ:");
                foreach (ListViewItem item in listView_service.Items)
                {
                    info.AppendLine("- " + item.Text);
                }

                richTextBox1.Text = info.ToString();
            }
        }
    }
}
