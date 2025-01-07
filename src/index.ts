import { ApolloServer } from "apollo-server";
import { QueueUtils } from './queue';
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
});
