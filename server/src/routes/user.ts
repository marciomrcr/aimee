import fastify, { FastifyInstance } from "fastify";
import { prisma } from "../lib/prisma";

export async function userRoutes(fastify: FastifyInstance) {
  fastify.get("/users/count", async () => {
    const countUsers = await prisma.user.count();

    return { countUsers };
  });

  fastify.get("/users", async () => {
    const findUsers = await prisma.user.findMany({
      orderBy: {
        name: "asc",
      },
    });

    return { findUsers };
  });
}
