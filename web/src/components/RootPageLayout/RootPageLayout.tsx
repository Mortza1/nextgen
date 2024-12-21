// import AsideMenu from "@app/components/AsideMenu";
import styles from "./styles.module.css";

export default function RootPageLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <main>
      {children}
    </main>
  );
}
