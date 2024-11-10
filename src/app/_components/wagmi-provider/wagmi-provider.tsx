'use client';

import React from 'react';
import { WagmiConfig, configureChains, createConfig } from 'wagmi';
import { Chain } from 'wagmi/chains';
import { MetaMaskConnector } from 'wagmi/connectors/metaMask';
import { publicProvider } from 'wagmi/providers/public';

// https://wagmi.sh/react/getting-started
// https://wagmi.sh/examples/connect-wallet
// https://docs.walletconnect.com/web3modal/nextjs/about

const klaytnTestnet = {
	id: 97,
	name: 'BNB Smart Chain Testnet',
	network: 'BNB',
	nativeCurrency: {
		decimals: 18,
		name: 'BNB',
		symbol: 'BNB',
	},
	rpcUrls: {
		default: { http: ['https://bsc-testnet.blockpi.network/v1/rpc/public'] },
		public: { http: ['https://bsc-testnet-rpc.publicnode.com'] },
	},
	blockExplorers: {
		etherscan: { name: 'bscscan', url: 'https://testnet.bscscan.com/' },
		default: { name: 'bscscan', url: 'https://testnet.bscscan.com/' },
	},
} as const satisfies Chain;

// Configure chains & providers with the Alchemy provider
const { chains, publicClient, webSocketPublicClient } = configureChains([klaytnTestnet], [publicProvider()]);

// Set up wagmi config
const wagmiConfig = createConfig({
	autoConnect: true,
	connectors: [new MetaMaskConnector({ chains })],
	publicClient,
	webSocketPublicClient,
});

export const WagmiProvider = function WagmiProvider({ children }: React.PropsWithChildren) {
	// Prevent nextjs 13 hydratation problem
	// https://github.com/wagmi-dev/create-wagmi/blob/main/templates/next/default/src/app/providers.tsx
	const [mounted, setMounted] = React.useState(false);
	React.useEffect(() => setMounted(true), []);

	return <WagmiConfig config={wagmiConfig}>{mounted && children}</WagmiConfig>;
};
