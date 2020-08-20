// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _ApiService implements ApiService {
  _ApiService(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    this.baseUrl ??= 'http://103.29.91.202:8083/totp_generator/api/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  getOTP(cpi) async {
    ArgumentError.checkNotNull(cpi, 'cpi');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'cpi': cpi};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request('gettotp',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{
              r'APIKey': 'AnzerITHealthcareMyanmarTOTPGenerator'
            },
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = OTPModel.fromJson(_result.data);
    return value;
  }

  @override
  verifyOTP(cpi, otpCode) async {
    ArgumentError.checkNotNull(cpi, 'cpi');
    ArgumentError.checkNotNull(otpCode, 'otpCode');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'cpi': cpi,
      r'OTP_Code': otpCode
    };
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'verification',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{
              r'APIKey': 'AnzerITHealthcareMyanmarTOTPGenerator'
            },
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = OTPVerifyResultModel.fromJson(_result.data);
    return value;
  }

  @override
  getPtInfo(cpi) async {
    ArgumentError.checkNotNull(cpi, 'cpi');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'cpi': cpi};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'getPtInfo',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{
              r'APIKey': 'AnzerITHealthcareMyanmarTOTPGenerator'
            },
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = PtInfo.fromJson(_result.data);
    return value;
  }

  @override
  getDoctorServices() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<List<dynamic>> _result = await _dio.request(
        'getSpecialities',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{
              r'APIKey': 'AnzerITHealthcareMyanmarTOTPGenerator'
            },
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) => DocServiceModel.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  getDoctor() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<List<dynamic>> _result = await _dio.request('getDoctors',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{
              r'APIKey': 'AnzerITHealthcareMyanmarTOTPGenerator'
            },
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) => DoctorModel.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  getAvailableDateAndTime(
      hospitalInst, startDate, endDate, deptCode, resType, docCode) async {
    ArgumentError.checkNotNull(hospitalInst, 'hospitalInst');
    ArgumentError.checkNotNull(startDate, 'startDate');
    ArgumentError.checkNotNull(endDate, 'endDate');
    ArgumentError.checkNotNull(deptCode, 'deptCode');
    ArgumentError.checkNotNull(resType, 'resType');
    ArgumentError.checkNotNull(docCode, 'docCode');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'HospitalInst': hospitalInst,
      r'startDate': startDate,
      r'endDate': endDate,
      r'deptCode': deptCode,
      r'resType': resType,
      r'docCode': docCode
    };
    final _data = <String, dynamic>{};
    final Response<List<dynamic>> _result = await _dio.request(
        'getAvailableDateAndTime',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{
              r'APIKey': 'AnzerITHealthcareMyanmarTOTPGenerator'
            },
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) =>
            AvailableDateAndTimeModel.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  submitAppointment(appModel) async {
    ArgumentError.checkNotNull(appModel, 'appModel');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(appModel?.toJson() ?? <String, dynamic>{});
    final Response _result = await _dio.request('submitApp',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{
              r'APIKey': 'AnzerITHealthcareMyanmarTOTPGenerator'
            },
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }
}
