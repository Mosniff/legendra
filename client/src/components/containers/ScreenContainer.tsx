export const ScreenContainer = ({
  children,
}: {
  children: React.ReactNode;
}) => {
  return <div className="bg-amber-500 w-full flex-grow p-2">{children}</div>;
};
