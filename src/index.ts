import { ApolloServer } from "apollo-server";
import { QueueUtils, QueryTaxSaleQueue, JobsEnum } from './queue';

import { schema } from "./schema";
export const server = new ApolloServer({
    schema,
});

const port = 3000;
server.listen({port}).then(({ url }) => {
    QueueUtils.initializeJobs();
    console.log(`🚀  Server ready at ${url}`);
    QueryTaxSaleQueue.add(JobsEnum.QUERY_TAX_SALE, { parcelNumber: '46-06-36-365-007.000-043' });
});
