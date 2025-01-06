import rootConfig from '../../config';
import { WorkerConfigType } from '../../types';
import { QueuesEnum } from '../../constants';

const config: WorkerConfigType = {
  ...rootConfig,
  queueName: QueuesEnum.QUERYTAXSALE,
  isSandboxed: true
}

export default config;