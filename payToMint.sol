function NFTImage({ tokenId, getCount }) {
  const contentId = 'PINATA_CONTENT_ID';
  const metadataURI = `${contentId}/${tokenId}.json`;
  const imageURI = `https://gateway.pinata.cloud/ipfs/${contentId}/${tokenId}.png`;

  const [isMinted, setIsMinted] = useState(false);
  useEffect(() => {
    getMintedStatus();
  }, [isMinted]);

  const getMintedStatus = async () => {
    const result = await contract.isContentOwned(metadataURI);
    console.log(result)
    setIsMinted(result);
  };

  const mintToken = async () => {
    const connection = contract.connect(signer);
    const addr = connection.address;
    const result = await contract.payToMint(addr, metadataURI, {
      value: ethers.utils.parseEther('0.05'),
    });

    await result.wait();
    getMintedStatus();
    getCount();
  };

  async function getURI() {
    const uri = await contract.tokenURI(tokenId);
    alert(uri);
  }
  return (
    <div>
      <img src={isMinted ? imageURI : 'img/placeholder.png'}></img>
        <h5>ID #{tokenId}</h5>
        {!isMinted ? (
          <button onClick={mintToken}>
            Mint
          </button>
        ) : (
          <button onClick={getURI}>
            Taken! Show URI
          </button>
        )}
    </div>
  );
}

export default Home;