import type { AxiosInstance } from "axios";

export interface IBaseConfig {
  readonly url: string;
  readonly httpClient: AxiosInstance;
}

export default class Base {
  protected readonly url: string;
  protected readonly httpClient: AxiosInstance;
  constructor(config: IBaseConfig) {
    this.url = config.url;
    this.httpClient = config.httpClient;
  }
}
