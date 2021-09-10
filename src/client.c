#include <signal.h>
#include <unistd.h>

#include "ft_stdio.h"
#include "ft_stdlib.h"

#include "minitalk.h"

volatile sig_atomic_t	g_ack;

static void	send_char(char c, pid_t pid)
{
	int	pos;

	pos = -1;
	while (++pos < BYTE_SIZE)
	{
		usleep(30);
		g_ack = ACK_N;
		if (c & (1 << pos))
		{
			if (kill(pid, SIGUSR1) < 0)
				ft_perror(CLIENT, E_KILL_FAIL);
		}
		else
		{
			if (kill(pid, SIGUSR2) < 0)
				ft_perror(CLIENT, E_KILL_FAIL);
		}
		while (!g_ack)
			;
	}
}

static void send_string(const char *str, pid_t pid)
{
	while(*str)
		send_char(*str++, pid);
	send_char('\n', pid);
}

void	handler(int signal, siginfo_t *info, void *ctx)
{
	static const char sig1[] = "SIGUSR1";
	static const char sig2[] = "SIGUSR2";
	const char *sig;

	(void)ctx;
	if (signal == SIGUSR1)
		sig = sig1;
	else
		sig = sig2;
	ft_printf("Server with pid %d received signal %s\n", info->si_pid, sig);
	g_ack = ACK_Y;
}

int	main(int argc, char *argv[])
{
	struct sigaction	sa;

	if (argc != 3)
		ft_error2(CLIENT, INV_ARGC_MSG, E_INV_ARGC);
	sa.sa_sigaction = handler;
	sigemptyset(&sa.sa_mask);
	sigaddset(&sa.sa_mask, SIGUSR1);
	sigaddset(&sa.sa_mask, SIGUSR2);
	sa.sa_flags = SA_SIGINFO;
	if (sigaction(SIGUSR1, &sa, NULL) < 0 || sigaction(SIGUSR2, &sa, NULL) < 0)
		ft_perror(SERVER, E_SIGACT_FAIL);
	send_string(argv[2], ft_atoi(argv[1]));
}
