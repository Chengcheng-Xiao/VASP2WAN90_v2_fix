program w90unk2unk
implicit none

   integer :: ngx, ngy, ngz, nk, nbnd, I, ibnd, nx, soc
   complex(kind=8), allocatable :: r_wvfn_nc(:, :, :)
   !character*20 :: wfnname_in,wfnname_out
   character(len=32) :: arg

   ! 201   format ('UNK',i5.5,'.','NC')
   ! 202   format ('UNK',i5.5,'.','NC.formatted')

   I = 0
   do
     call get_command_argument(I, arg)
     if (LEN_TRIM(arg) == 0) exit
     if (I == 1) then
       read(arg, *) soc
       if (soc == 1) then
	 write (*,*) "Non-collinear spin file(s)."
       else if (soc == 0) then
         continue
       else
         write (*,*) "please enter file type: 0-collinear | 1-noncollinear"
	 exit
       endif
     endif
     if (I > 1) then
       write (*,*) "Converting File: "//TRIM(arg)

       ! open file
       open(1, file=TRIM(arg), FORM='UNFORMATTED')

       read (1) ngx, ngy, ngz, nk, nbnd
       ! write (*,*) ngx*ngy*ngz*nbnd

       ! allocate array to store data
       if (soc) then
         allocate (r_wvfn_nc(ngx*ngy*ngz, nbnd, 2))
       else
	 allocate (r_wvfn_nc(ngx*ngy*ngz, nbnd, 1))
       endif

       ! read-in actual data
       do ibnd=1,nbnd
	 if (soc == 1) then
           read(1) (r_wvfn_nc(nx, ibnd, 1), nx=1, ngx*ngy*ngz)
           read(1) (r_wvfn_nc(nx, ibnd, 2), nx=1, ngx*ngy*ngz)
	 else
           read(1) (r_wvfn_nc(nx, ibnd, 1), nx=1, ngx*ngy*ngz)
	 endif
       enddo
       
       close(1)

       ! get new file name (here, I choose to overwrite.)
       open(2, file=TRIM(arg)//'.formated',FORM='FORMATTED')
       
       write(2,*) ngx, ngy, ngz, nk, nbnd
       do ibnd=1,nbnd
         !write(*,*) ibnd
	 if (soc == 1) then
           write(2,'(2ES20.10)') (r_wvfn_nc(nx, ibnd, 1), nx=1, ngx*ngy*ngz)
           write(2,'(2ES20.10)') (r_wvfn_nc(nx, ibnd, 2), nx=1, ngx*ngy*ngz)
         else
           write(2,'(2ES20.10)') (r_wvfn_nc(nx, ibnd, 1), nx=1, ngx*ngy*ngz)
	 endif
       enddo
       
       close(2)
       
       deallocate (r_wvfn_nc)
     endif
     I = I+1  
   enddo

end program w90unk2unk
