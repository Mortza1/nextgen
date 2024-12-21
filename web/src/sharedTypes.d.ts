type ResponseStatusCode = number;

interface ResponseInfo {
  description: string;
  httpCode: ResponseStatusCode;
  message: string;
}

interface CommonResponseApi<T = unknown> {
  data: T;
  responseInfo: ResponseInfo;
  statusCode: ResponseStatusCode;
}
