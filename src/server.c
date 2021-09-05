#include <signal.h>
#include <stddef.h>
#include <unistd.h>

#include "ft_stdio.h"

#include "minitalk.h"

void	handler(int signal, siginfo_t *info, void *ctx)
{
	static unsigned char	ch = 0;
	static int	pos = 0;

	(void)ctx;
	if (signal == SIGUSR1)
		ch |= 1 << pos;
	pos++;
	if (pos == 8)
	{
		write(STDOUT_FILENO, &ch, sizeof(ch));
		pos = 0;
		ch = 0;
	}
	if (kill(info->si_pid, signal) < 0)
		ft_perror(SERVER, E_KILL_FAIL);
}

int main()
{
	struct sigaction	sa;
	sigset_t	set;

	sa.sa_sigaction = handler;
	sigemptyset(&set);
	sigaddset(&set, SIGUSR1);
	sigaddset(&set, SIGUSR2);
	sa.sa_mask = set;
	sa.sa_flags = SA_SIGINFO;
	if (sigaction(SIGUSR1, &sa, NULL) < 0 || sigaction(SIGUSR2, &sa, NULL) < 0)
		ft_perror(SERVER, E_SIGACT_FAIL);
	ft_printf("Server pid is %d\n", getpid());
	while(1)
		pause();
}
