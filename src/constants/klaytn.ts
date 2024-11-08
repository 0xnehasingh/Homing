export type NetworkType = 'testnet' | 'mainnet';

export const NETWORK_DATA_MAP = {
	mainnet: {
		general: {
			HedraPrice: 0.5,
		},
		contracts: {
			HouseformManager: {
				address: '',
			},
			HouseformShare: {
				address: '',
			},
		},
	},
	testnet: {
		general: {
			HedraPrice: 0.5,
		},
		contracts: {
			HouseformManager: {
				address: '0x52555F4E27d66e11ff5371F88d6D426aC32b708f',
			},
			HouseformShare: {
				address: '0xA688e049F4E7126E953eA9684A8c2BdDB1A72315',
			},
		},
	},
};

export class KlaytnConstants {
	// This defines the network to be used through the app (mainnet or testnet) loaded through env
	public static NETWORK_TYPE = (process.env.NEXT_PUBLIC_NETWORK_TYPE || 'testnet') as NetworkType;
	// This is always used to access network data
	public static NETWORK_DATA = NETWORK_DATA_MAP[KlaytnConstants.NETWORK_TYPE];
}
