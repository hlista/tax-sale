import { ConnectionOptions, DefaultJobOptions } from 'bullmq';
import { JobsEnum, QueuesEnum } from './constants';

export type JobType = keyof typeof JobsEnum;
export type QueueType = keyof typeof QueuesEnum;

export interface BaseConfigType {
  queueName: QueuesEnum,
  connection: ConnectionOptions
}

export interface WorkerConfigType extends BaseConfigType {
  isSandboxed?: boolean,
  concurrency?: number
}

export interface QueueConfigType extends BaseConfigType {
  defaultJobOptions?: DefaultJobOptions
}