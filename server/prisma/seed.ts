import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

async function main() {
  const role = await prisma.role.create({
    data: {
      name: "ADMIN",
    },
  });

  const user = await prisma.user.create({
    data: {
      role: {
        connect: {
          id: role.id,
        },
      },
      name: "Márcio Rodrigues",
      email: "marinho@gmail.com",
      avatarUrl: "https://github.com/marciomrcr.png",
    },
  });

  const poll = await prisma.poll.create({
    data: {
      title: "Bolão 01",
      code: "BOL001",
      ownerId: user.id,
      participants: {
        create: {
          userId: user.id,
        },
      },
    },
  });

  await prisma.game.create({
    data: {
      date: "2022-11-04T16:05:53.449Z",
      firstTeamCountryCode: "BR",
      secondTeamCountryCode: "DE",
    },
  });

  await prisma.game.create({
    data: {
      date: "2022-11-04T16:05:53.449Z",
      firstTeamCountryCode: "BR",
      secondTeamCountryCode: "AR",
      guesses: {
        create: {
          firstTeamPoint: 2,
          secondTeamPoint: 0,
          participants: {
            connect: {
              userId_pollId: {
                userId: user.id,
                pollId: poll.id,
              },
            },
          },
        },
      },
    },
  });
}
main();
