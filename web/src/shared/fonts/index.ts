import { Montserrat } from "next/font/google";
import { IBM_Plex_Sans } from "next/font/google";


export const montserrat = Montserrat({ subsets: ["latin"] });
export const ibmPlexSans = IBM_Plex_Sans({
    subsets: ["latin"],
    weight: "100"
});
