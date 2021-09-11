/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   server_bonus.c                                     :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: nalysann <urbilya@gmail.com>               +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2021/09/11 07:03:14 by nalysann          #+#    #+#             */
/*   Updated: 2021/09/11 07:03:17 by nalysann         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <signal.h>
#include <stddef.h>
#include <unistd.h>

#include "ft_stdio.h"

#include "minitalk.h"

void	handler(int signal, siginfo_t *info, void *ctx)
{
	static unsigned char	byte = 0;
	static int				shift = 0;

	(void)ctx;
	if (signal == SIGUSR1)
		byte |= 1 << shift;
	if (++shift == BYTE_SIZE)
	{
		write(STDOUT_FILENO, &byte, sizeof(byte));
		byte = 0;
		shift = 0;
	}
	if (kill(info->si_pid, signal) < 0)
		ft_perror(SERVER, E_KILL_FAIL);
}

int	main(void)
{
	struct sigaction	sa;

	ft_printf("Server pid is %d\n", getpid());
	sa.sa_sigaction = handler;
	sigemptyset(&sa.sa_mask);
	sigaddset(&sa.sa_mask, SIGUSR1);
	sigaddset(&sa.sa_mask, SIGUSR2);
	sa.sa_flags = SA_SIGINFO;
	if (sigaction(SIGUSR1, &sa, NULL) < 0 || sigaction(SIGUSR2, &sa, NULL) < 0)
		ft_perror(SERVER, E_SIGACT_FAIL);
	while (1)
		pause();
}
