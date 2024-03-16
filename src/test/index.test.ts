import { ZKFactorContract, ZKFactorContractArtifact } from "../artifacts/ZKFactor"
import { AccountWallet, CompleteAddress, PXE, waitForPXE, AztecAddress, TxStatus, createPXEClient, Contract, ExtendedNote, Fr, Note, computeMessageSecretHash, CheatCodes} from "@aztec/aztec.js";
import { getInitialTestAccountsWallets } from "@aztec/accounts/testing"

const setupSandbox = async () => {
    const { PXE_URL = 'http://localhost:8080' } = process.env;
    const pxe = createPXEClient(PXE_URL);
    await waitForPXE(pxe);
    return pxe;
};

describe("ZK Fac", () => {
    let pxe: PXE;
    let cc: CheatCodes
    let ownerWallet: AccountWallet;
    let ownerAddress: CompleteAddress;
    let zkFactor: Contract;
    let zkFactorAddress: AztecAddress

    beforeAll(async () => {
        pxe = await setupSandbox();
        [ownerWallet] = await getInitialTestAccountsWallets(pxe);
        ownerAddress = ownerWallet.getCompleteAddress();

        zkFactor = await Contract.deploy(ownerWallet, ZKFactorContractArtifact, []).send().deployed()
        zkFactorAddress = zkFactor.address;
        console.log(`deployed at ${zkFactor.address.toString()}`)

        cc = CheatCodes.create('http://locahost:8545', pxe);

    }, 100_000)

    it("Deploys the contract", async () => {
        const receipt = await zkFactor.methods.setReferencePoint(0, 4, 6).send().wait();
        
    }, 100_000);

});