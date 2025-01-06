import { ApolloServer } from "apollo-server";
import { QueueUtils, MailbotQueue, JobsEnum } from './queue';

import { schema } from "./schema";
export const server = new ApolloServer({
    schema,
});

const port = 3000;
server.listen({port}).then(({ url }) => {
    QueueUtils.initializeJobs();
    console.log(`🚀  Server ready at ${url}`);
    MailbotQueue.add(JobsEnum.SEND_EMAIL, { email: 'test@test.com' });
});
