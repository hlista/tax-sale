import rootConfig from '../../config';
import { WorkerConfigType } from '../../types';
import { QueuesEnum } from '../../constants';

const config: WorkerConfigType = {
  ...rootConfig,
  queueName: QueuesEnum.MAILBOT,
  isSandboxed: false
}

export default config;