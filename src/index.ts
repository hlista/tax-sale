import { ApolloServer } from "apollo-server";
import { QueueUtils, QueryTaxSaleQueue, MailbotQueue, JobsEnum } from './queue';
import { PrismaClient } from '@prisma/client';

import { schema } from "./schema";
export const server = new ApolloServer({
    schema,
});

export const prisma = new PrismaClient();

const port = 3000;
server.listen({port}).then(({ url }) => {
    QueueUtils.initializeJobs();
    console.log(`🚀  Server ready at ${url}`);
    // MailbotQueue.upsertJobScheduler(
    //     'my-scheduler-id',
    //     {
    //         every: 10000
    //     },
    //     {
    //         name: JobsEnum.SEND_EMAIL,
    //         data: {
    //             foo: 'bar'
    //         }
    //     }
    // )
    QueryTaxSaleQueue.add(JobsEnum.QUERY_TAX_SALE, { parcelNumber: '46-06-36-365-007.000-043' });
});
