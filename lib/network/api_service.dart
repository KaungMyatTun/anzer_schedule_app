import 'package:anzer_schedule_app/network/model/available_date_time_model.dart';
import 'package:anzer_schedule_app/network/model/doc_service_model.dart';
import 'package:anzer_schedule_app/network/model/doctor_model.dart';
import 'package:anzer_schedule_app/network/model/otp_model.dart';
import 'package:anzer_schedule_app/network/model/otp_verifyResult_model.dart';
import 'package:anzer_schedule_app/network/model/pt_info.dart';
import 'package:anzer_schedule_app/network/model/submit_app_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "http://103.29.91.202:8083/totp_generator/api/")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  static ApiService create() {
    final dio = Dio();
    dio.interceptors.add(PrettyDioLogger());
    return ApiService(dio);
  }

  @Headers(<String, String>{"APIKey": "AnzerITHealthcareMyanmarTOTPGenerator"})
  @GET("gettotp")
  Future<OTPModel> getOTP(@Query("cpi") String cpi);

  @Headers(<String, String>{"APIKey": "AnzerITHealthcareMyanmarTOTPGenerator"})
  @POST("verification")
  Future<OTPVerifyResultModel> verifyOTP(
      @Query("cpi") String cpi, @Query("OTP_Code") String otpCode);

  @Headers(<String, String>{"APIKey": "AnzerITHealthcareMyanmarTOTPGenerator"})
  @GET("getPtInfo")
  Future<PtInfo> getPtInfo(@Query("cpi") String cpi);

  @Headers(<String, String>{"APIKey": "AnzerITHealthcareMyanmarTOTPGenerator"})
  @GET("getSpecialities")
  Future<List<DocServiceModel>> getDoctorServices();

  @Headers(<String, String>{"APIKey": "AnzerITHealthcareMyanmarTOTPGenerator"})
  @GET("getDoctors")
  Future<List<DoctorModel>> getDoctor();

  @Headers(<String, String>{"APIKey": "AnzerITHealthcareMyanmarTOTPGenerator"})
  @GET('getAvailableDateAndTime')
  Future<List<AvailableDateAndTimeModel>> getAvailableDateAndTime(
      @Query('HospitalInst') String hospitalInst,
      @Query('startDate') String startDate,
      @Query('endDate') String endDate,
      @Query('deptCode') String deptCode,
      @Query('resType') String resType,
      @Query('docCode') String docCode);

  @Headers(<String, String>{"APIKey": "AnzerITHealthcareMyanmarTOTPGenerator"})
  @POST("submitApp")
  Future<dynamic> submitAppointment(@Body() SubmitAppModel appModel);
}
