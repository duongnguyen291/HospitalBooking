var config=require('../dbConfig');
const sql= require('msnodesqlv8');

const AppointmentModel = {
  getAllAppointments: async () => {
    try {
      const [appointments] = await sql.promise().query(config, `
      select staff.staff_id,
      patient.patient_id, 
      Appointment.Appointment_Id,
      Appointment.Service_ID,
      Appointment.Start_Time,
      Appointment.End_Time,
      Appointment.Room_ID,
      Appointment.Payment 
      from Appointment
      join Staff on staff.staff_id=Appointment.staff_id
      join patient on patient.patient_id=Appointment.patient_id;
    `);

      return appointments;
    } catch (error) {
      console.error("Error in getAllAppointments:", error);
      throw error;
    }
  },

  getAllAppointmentsStaffId: async (PatientID) => {
    try {
      // Lấy Doctor_id từ User_id
      const [staffResult] = await sql
        .promise()
        .query(config, "select Staff_ID from Appointment where Patient_ID = ?", [PatientID]);

      if (!staffResult || !staffResult.length) {
        // Trả về mảng trống nếu không tìm thấy Doctor_id
        return [];
      }

      const staffID = staffResult[0].Staff_ID;

      // Truy vấn các cuộc hẹn từ Doctor_id
      const [appointments] = await sql.promise().query(config,
        `
        select 
          patient.patient_id,
          patient.Name,
          Appointment.Appointment_Id,
          Appointment.Staff_ID,
          staff.Name
          from Appointment
          join patient on patient.Patient_ID= appointment.patient_ID
          join staff on staff.staff_ID=appointment.staff_ID
          where appointment.staff_ID= ? ;
          `,
          [staffID]
        );
  
        return appointments;
      } catch (error) {
        console.error("Error in getAllAppointmentsStaffId:", error);
        throw error;
      }
    },
  
    updateStatus: async (appointmentId, newStatus) => {
      try {
        const [result] = await sql
          .promise()
          .query(config,
            "UPDATE appointment SET Status = ? WHERE Appointment_id = ?",
            [newStatus, appointmentId]
            );
    
          return result.affectedRows > 0; // Trả về true nếu cập nhật thành công
        } catch (error) { 
          console.error("Error updating status:", error);
          throw error;
        }
      },
    
      getAppointmentInfo: async (PatientID) => {
        try {
          // Lấy doctor_id từ user_id
          const [Staffresult] = await sql
            .promise()
            .query(config, "select Staff_ID from Appointment where Patient_ID = ?", [PatientID]);
    
          // Kiểm tra xem có doctor_id hay không
          if (Staffresult.length === 0) {
            // Nếu không tìm thấy doctor_id, trả về null
            return null;
        }
  
        const StaffID = Staffresult[0].Staff_ID;
  
        // Truy vấn SQL để lấy thông tin cuộc hẹn dựa trên doctor_id
        const [appointmentInfo] = await sql.promise().query(config,
          `
          select 
            Appointment.Appointment_Id,
            appointment.patient_ID,
            Appointment.Staff_ID,
            Appointment.Service_ID,
            Appointment.Start_Time,
            Appointment.End_Time,
            Appointment.Room_ID,
            Appointment.Payment 
            from Appointment
          where appointment.staff_ID= ? ;
          `,
          [StaffID]
        );
// Kiểm tra xem có dữ liệu hay không
if (appointmentInfo.length > 0) {
    // Nếu có dữ liệu, trả về một mảng chứa thông tin của tất cả cuộc hẹn
    return appointmentInfo.map((appointment) => ({
      roomNumber: appointment.RoomNumber,
      date: appointment.Date,
      time: appointment.Time,
    }));
  } else {
    // Không tìm thấy cuộc hẹn
    return null;
  }
} catch (error) {
  console.error("Error in getAppointmentInfo:", error);
  throw error;
}
},
};
module.exports = AppointmentModel;    